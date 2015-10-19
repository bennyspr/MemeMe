//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Benny on 10/17/15.
//  Copyright © 2015 Benny Rodriguez. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    

//    @IBOutlet weak var topTextField: UITextField!
//    @IBOutlet weak var bottomTextField: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    func configureWithInfo(meme: Meme) {
        
//        topTextField.defaultTextAttributes = memeTextAttributes
//        topTextField.text = meme.topText
//        
//        bottomTextField.defaultTextAttributes = memeTextAttributes
//        bottomTextField.text = meme.bottomText
        
        backgroundView = UIImageView(image: meme.originalImage)
    }
    
}
