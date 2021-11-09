//
//  SportExtation.swift
//  app16
//
//  Created by administrator on 28/10/2021.
//

import Foundation
import UIKit
extension SportTableView :  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
   

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // take a photo or select a photo
            
            // action sheet - take photo or choose photo
            picker.dismiss(animated: true, completion: nil)
            print(info)
            
            guard let selectedImage = info[.editedImage] as? UIImage else {
                return
            }
           
            if let jpegData = selectedImage.jpegData(compressionQuality: 0.8) {
                sports[selectedSportIndex].image = jpegData
                do {
                    try managedObjectContext.save()
                     print("Success!")
            } catch {
                    let nserror = error as NSError
                    print("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
            }
            }

            tableView.reloadData()

            
            
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
    
    
}

extension SportTableView: ImageDelegte {
    func picherimage(cell: CustemCellSports) {
        selectedSportIndex = tableView.indexPath(for: cell)?.row ?? 0
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
}

