//
//  SportTableView.swift
//  app16
//
//  Created by administrator on 09/11/2021.
//

import UIKit

class SportTableView: UITableViewController {
  


    var selectedImage = UIImage()
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedSportIndex = 0
    var sports = [Sports]()
   
    
    var image : UIImage?
    // that for change the color of cell
//    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // fetch data from data core
        do{
            let sports = try managedObjectContext.fetch(Sports.fetchRequest())
        } catch{
            print(error)
        }
        
    }
    
    
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
        fetchSportEntries()
     }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sports.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustemCellSports
        cell.ImageDelegte = self
        cell.configure(with: sports[indexPath.row])
        return cell
    }
    

    @IBAction func addSport(_ sender: UIBarButtonItem)
      {
        // make alert
        let alert = UIAlertController(title: "New Sport", message: "Add a new Sport", preferredStyle: .alert)
        // add text field to the alert
        alert.addTextField(configurationHandler: nil)
        
        //make action to save sport
        let saveAction = UIAlertAction.init(title: "Save", style: .default){_ in
            guard let text = alert.textFields else {return}
            // stored the text that user write it
            let textFeild = text[0]
            let newSport = Sports(context: self.managedObjectContext)
            newSport.name = textFeild.text
            self.savSportEntries()
        }
        
        let CancelAcation = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //tell the alert to add tow button action
        alert.addAction(saveAction)
        alert.addAction(CancelAcation)
        present(alert, animated: true, completion: nil)
        
    }
   
   // func for pressed on accessory and go to the next View
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let desCV = storyboard?.instantiateViewController(identifier: "Player") as? PlayerTableViewController
        desCV?.sport = sports[indexPath.row]
        desCV?.titleSport = sports[indexPath.row].name
        navigationController?.pushViewController(desCV!, animated: true)
    }
   
    // edit funcation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UpdateSport(path: indexPath.row)
    }
    
    //for delete Sport
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        DelteSport(path: indexPath.row)
        tableView.reloadData()
        
    }
    
    func DelteSport(path:Int){
        managedObjectContext.delete(sports[path])
            do {
                try managedObjectContext.save()
                sports.remove(at: path)
            }
            catch {
                print(error)
            }
                
    }
    // Update the Sport in Data Core
    func UpdateSport(path: Int){
        let editSports = sports[path]
        // make alert first
        let alertEdit = UIAlertController(title: "Edit Sport", message: "Edit a Sport", preferredStyle: .alert)
        alertEdit.addTextField { (textField) in
            textField.text = editSports.name
        }
        let editAction = UIAlertAction(title: "Edit", style: .default){_ in
            guard let EditSport =  alertEdit.textFields else {return}
            self.sports[path].name = EditSport[0].text
            self.savSportEntries()
            
        }
        let CancelAcation = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //tell the alert to add tow button action
        alertEdit.addAction(editAction)
        alertEdit.addAction(CancelAcation)
        present(alertEdit, animated: true, completion: nil)
    }
    
    var button : UIButton?
    func picherimage(sender: UIButton) {
        presentPhotoActionSheet()
        self.button = sender
    }
    
    
    func presentPhotoActionSheet(){
            let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
                self?.presentCamera()
            }))
            actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
                self?.presentPhotoPicker()
            }))
            
            present(actionSheet, animated: true)
        }
        func presentCamera() {
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
        }
        func presentPhotoPicker() {
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
        }
    
    func savSportEntries() {
           do {
               try managedObjectContext.save()
               print("Successfully saved")
           } catch {
               print("Error when saving: \(error)")
           }
        fetchSportEntries()
       }
       func fetchSportEntries() {
           do {
            sports = try managedObjectContext.fetch(Sports.fetchRequest())
           
               print("Success")
           } catch {
               print("Error: \(error)")
           }
           tableView.reloadData()
       }
}

