//
//  PlayerTableViewController.swift
//  app16
//
//  Created by administrator on 25/10/2021.
//

import UIKit

class PlayerTableViewController: UITableViewController {

    var titleSport : String?
    var players = [Players]()
    var sport : Sports!
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // fetch data from data core
        do{
            let player = try managedObjectContext.fetch(Players.fetchRequest())
        } catch{
            print(error)
        }
        
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.title = titleSport!

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addPlayer(sender:)))
    }

    // MARK: - Table view data source

    @objc func addPlayer(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Player", message: "add a new player", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.textFields![0].placeholder = "first name and last name"
        alert.textFields![1].placeholder = "Age"
        alert.textFields![2].placeholder = "Height"
        
        let saveAction = UIAlertAction.init(title: "Save", style: .default){_ in
            guard let text = alert.textFields else {return}
            // stored the text that user write it
            let name = text[0]
            let age = text[1]
            let height = text[2]
            
           let newPlayer = Players(context: self.managedObjectContext)
            guard let nameplayer = name.text else {return}
            newPlayer.name = nameplayer
            newPlayer.age = Int64(age.text!)!
            newPlayer.height = Double(height.text!)!
            self.sport.addToPlayers(newPlayer)
            self.savSportEntries()
        }
        
        let CancelAcation = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //tell the alert to add tow button action
        alert.addAction(saveAction)
        alert.addAction(CancelAcation)
        present(alert, animated: true, completion: nil)

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sport.players?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellP", for: indexPath) as! CustemPlayer
        let player = self.sport.players?[indexPath.row] as! Players
        
        cell.name.text = player.name!
        cell.age.text = "\(player.age)"
        cell.height.text = "\(player.height)"
        // Configure the cell...

        return cell
    }
    
    //for delete Sport
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        DeletePlyer(path: indexPath.row)
        tableView.reloadData()
        
    }
    
    func DeletePlyer(path:Int){
        managedObjectContext.delete(sport.players?[path] as! Players)
            do {
                try managedObjectContext.save()
             
            }
            catch {
                print(error)
            }
                
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
            players = try managedObjectContext.fetch(Players.fetchRequest())
           
               print("Success")
           } catch {
               print("Error: \(error)")
           }
           tableView.reloadData()
       }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
