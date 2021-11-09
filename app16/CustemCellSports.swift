//
//  CustemCellSports.swift
//  app16
//
//  Created by administrator on 25/10/2021.
//

import UIKit

class CustemCellSports: UITableViewCell  {
  
    


    @IBOutlet weak var sports: UILabel!
    var ImageDelegte : ImageDelegte?

    @IBOutlet weak var ImageViewSport: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        ImageViewSport.image = nil
    }

    func configure(with sport: Sports) {
        sports.text = sport.name
        if let imageData = sport.image {
            ImageViewSport.image = UIImage(data: imageData)
            ImageViewSport.isHidden = false
            imageButton.setTitle("", for: .normal)
        } else {
            ImageViewSport.isHidden = true
           imageButton.setTitle("Add image", for: .normal)
        }
    }
    @IBAction func addimage(_ sender: UIButton) {
        ImageDelegte?.picherimage(cell: self)
        
    }
    
}
