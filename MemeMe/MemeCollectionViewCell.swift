//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Benny on 10/17/15.
//  Copyright © 2015 Benny Rodriguez. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    func configureWithInfo(meme: Meme) {
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        topTextField.text = meme.topText
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        bottomTextField.text = meme.bottomText
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.topTextField.layoutIfNeeded()
            self.bottomTextField.layoutIfNeeded()
        })
        
        backgroundView = UIImageView(image: meme.originalImage)
    }
    
}
