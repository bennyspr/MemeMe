//
//  ViewController.swift
//  MemeMe
//
//  Udacity iOS Developer Nanodegree
//  MemeMe v2.0 Project
//
//  Notes:
//  I have problem implementing AVCaptureDevice 'requestAccessForMediaType' function for 
//  creating the question view for requesting access again to the camera.
//
//  Created by Benny on 9/28/15.
//  Copyright © 2015 Benny Rodriguez. All rights reserved.
//

import AVFoundation
import UIKit

private enum MemmeMeBarButton {
    
    case Share, Cancel, FlexibleSpace, FixedSpace, Camera, Album
}

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    lazy var shareButton: UIBarButtonItem = {
        
        return self.barButtonItemByOption(.Share)
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        
        return self.barButtonItemByOption(.Cancel)
    }()
    
    lazy var cameraButton: UIBarButtonItem = {
        
        return self.barButtonItemByOption(.Camera)
    }()
    
    lazy var albumButton: UIBarButtonItem = {
       
        return self.barButtonItemByOption(.Album)
    }()
    
    var pushViewBoolean: Bool!
    
    let defaultTextForTop = "TOP"
    let defaultTextForBottom = "BOTTOM"
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        shareButton.enabled = false
        
        let flexibleItem = barButtonItemByOption(.FlexibleSpace)
        
        topToolbar.setItems([shareButton, flexibleItem, cancelButton], animated: true)
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            cameraButton.enabled = false
        }
        
        let fixedItem = barButtonItemByOption(.FixedSpace, widthForFixedSpace: 50.0)

        bottomToolbar.setItems([flexibleItem, cameraButton, fixedItem, albumButton, flexibleItem], animated: true)
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        topTextField.text = defaultTextForTop
        topTextField.textAlignment = NSTextAlignment.Center
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.delegate = self
        bottomTextField.text = defaultTextForBottom
        bottomTextField.textAlignment = NSTextAlignment.Center
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let push = pushViewBoolean where push == true {
            
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let push = pushViewBoolean where push == true {
            
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue // of CGRect
        return (keyboardSize?.CGRectValue().height)!
    }
    
    private func barButtonItemByOption(option: MemmeMeBarButton, widthForFixedSpace: CGFloat = 0) -> UIBarButtonItem {
        
        switch option {
            
        case .Share:
            
            return UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonAction")
            
        case .Cancel:
            
            return UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelButtonAction")
            
        case .FlexibleSpace:
            
            return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            
        case .FixedSpace:
            
            let button = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            button.width = widthForFixedSpace
            return button
            
        case .Camera:
            
            return UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "cameraButtonAction")
            
        case .Album:
            
            return UIBarButtonItem(title: "Album", style: .Done, target: self, action: "albumButtonAction")
        }
    }
    
    private func configureHiddenPropertyToolbarsAndNavbar(hidden: Bool) {
        
        topToolbar.hidden = hidden
        bottomToolbar.hidden = hidden
        navigationController?.navigationBarHidden = hidden
    }
    
    private func configureShareEnableState(state: Bool) {
        
        if state {
            
            shareButton.enabled = true
            
        } else {
         
            shareButton.enabled = false
            cancelButton.enabled = false
            topTextField.text = defaultTextForTop
            bottomTextField.text = defaultTextForBottom
            imageView.image = nil
        }
    }
    
    private func showCamera() {
        
        let camera = UIImagePickerController()
        
        camera.delegate = self
        
        camera.allowsEditing = false
        
        camera.sourceType = UIImagePickerControllerSourceType.Camera
        
        camera.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
        
        camera.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        
        presentViewController(camera, animated: true, completion: nil)
    }
    
    // Create a UIImage that combines the image view and the labels.
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        configureHiddenPropertyToolbarsAndNavbar(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        var memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Crop the image to the CGRect of the provided image
        if let cropedImage = CGImageCreateWithImageInRect(memedImage.CGImage, imageView.frame) {
            
            memedImage = UIImage(CGImage: cropedImage)
        }
        
        // Show toolbar and navbar
        configureHiddenPropertyToolbarsAndNavbar(false)
        
        return memedImage
    }
    
    
    
    func shareButtonAction() {
        
        pushViewBoolean = false
        
        // Generate a memed image
        let meme = Meme(
            topText: (topTextField.text?.trim())!,
            bottomText: (bottomTextField.text?.trim())!,
            originalImage: imageView.image!,
            memedImaged: generateMemedImage()
        )
        
        // Add it to the memeas array on the Application Delegate
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.memes.append(meme)
        
        let activityView = UIActivityViewController(activityItems: [meme.memedImaged], applicationActivities: nil)

        presentViewController(activityView, animated: true, completion: nil)
    }
    
    func cancelButtonAction() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // http://stackoverflow.com/questions/27646107/how-to-check-if-the-user-gave-permission-to-use-the-camera
    func cameraButtonAction() {
        
        if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) ==  AVAuthorizationStatus.Authorized {
            
            // Already Authorized
            showCamera()
            
        } else {
            
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                
                if granted == true {
                    
                    // User granted. Code because this block may be executed in a thread.
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.showCamera()
                    })
                    
                } else {
                    
                    // User Rejected
                    UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                }
            });
        }
    }
    
    func albumButtonAction() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}

// MARK: UIImagePickerControllerDelegate
extension MemeEditorViewController: UIImagePickerControllerDelegate {
    
    // http://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            configureShareEnableState(true)
            
        } else {
            
            configureShareEnableState(false)
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

// MARK: UITextFieldDelegate
extension MemeEditorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.text?.trim() == "" {
            
            if textField == topTextField {
                
                textField.text = defaultTextForTop
                
            } else {
                
                textField.text = defaultTextForBottom
            }
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == bottomTextField {
            
            pushViewBoolean = true
            
        } else {
            
            pushViewBoolean = false
        }
        
        if textField.text == defaultTextForBottom || textField.text == defaultTextForTop {
            
            textField.text = ""
        }
    }
}


