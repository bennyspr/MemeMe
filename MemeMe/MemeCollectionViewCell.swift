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
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!,
        NSStrokeWidthAttributeName : -3.0
    ] as [String : Any]
    
    func configureWithInfo(_ meme: Meme) {
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.center
        topTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        topTextField.text = meme.topText
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.center
        bottomTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        bottomTextField.text = meme.bottomText
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.topTextField.layoutIfNeeded()
            self.bottomTextField.layoutIfNeeded()
        })
        
        backgroundView = UIImageView(image: meme.originalImage)
    }
    
}
