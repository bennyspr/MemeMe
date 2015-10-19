//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Benny on 10/18/15.
//  Copyright © 2015 Benny Rodriguez. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithInfo(meme: Meme) {
        
        topLabel.text = "\(meme.topText)...\(meme.bottomText)"
        
        backgroundImage.image = meme.originalImage
    }
    

}
