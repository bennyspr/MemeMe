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
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!,
        NSStrokeWidthAttributeName : -3.0
    ] as [String : Any]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.center
        topTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithInfo(_ meme: Meme) {
        
        topTextField.text = meme.topText
        
        bottomTextField.text = meme.bottomText
        
        mainLabel.text = meme.topText + " " + meme.bottomText
        
        backgroundImage.image = meme.originalImage
    }
    

}
