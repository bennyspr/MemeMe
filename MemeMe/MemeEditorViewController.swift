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
    
    case share, cancel, flexibleSpace, fixedSpace, camera, album
}

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    lazy var shareButton: UIBarButtonItem = {
        
        return self.barButtonItemByOption(.share)
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        
        return self.barButtonItemByOption(.cancel)
    }()
    
    lazy var cameraButton: UIBarButtonItem = {
        
        return self.barButtonItemByOption(.camera)
    }()
    
    lazy var albumButton: UIBarButtonItem = {
       
        return self.barButtonItemByOption(.album)
    }()
    
    var pushViewBoolean: Bool!
    
    let defaultTextForTop = "TOP"
    let defaultTextForBottom = "BOTTOM"
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        shareButton.isEnabled = false
        
        let flexibleItem = barButtonItemByOption(.flexibleSpace)
        
        topToolbar.setItems([shareButton, flexibleItem, cancelButton], animated: true)
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            cameraButton.isEnabled = false
        }
        
        let fixedItem = barButtonItemByOption(.fixedSpace, widthForFixedSpace: 50.0)

        bottomToolbar.setItems([flexibleItem, cameraButton, fixedItem, albumButton, flexibleItem], animated: true)
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        topTextField.text = defaultTextForTop
        topTextField.textAlignment = NSTextAlignment.center
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.delegate = self
        bottomTextField.text = defaultTextForBottom
        bottomTextField.textAlignment = NSTextAlignment.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard notifications
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override var prefersStatusBarHidden : Bool {
        
        return true
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let push = pushViewBoolean, push == true {
            
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        if let push = pushViewBoolean, push == true {
            
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue // of CGRect
        return (keyboardSize?.cgRectValue.height)!
    }
    
    fileprivate func barButtonItemByOption(_ option: MemmeMeBarButton, widthForFixedSpace: CGFloat = 0) -> UIBarButtonItem {
        
        switch option {
            
        case .share:
            
            return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(MemeEditorViewController.shareButtonAction))
            
        case .cancel:
            
            return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(MemeEditorViewController.cancelButtonAction))
            
        case .flexibleSpace:
            
            return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
        case .fixedSpace:
            
            let button = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            button.width = widthForFixedSpace
            return button
            
        case .camera:
            
            return UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(MemeEditorViewController.cameraButtonAction))
            
        case .album:
            
            return UIBarButtonItem(title: "Album", style: .done, target: self, action: #selector(MemeEditorViewController.albumButtonAction))
        }
    }
    
    fileprivate func configureHiddenPropertyToolbarsAndNavbar(_ hidden: Bool) {
        
        topToolbar.isHidden = hidden
        bottomToolbar.isHidden = hidden
        navigationController?.isNavigationBarHidden = hidden
    }
    
    fileprivate func configureShareEnableState(_ state: Bool) {
        
        if state {
            
            shareButton.isEnabled = true
            
        } else {
         
            shareButton.isEnabled = false
            cancelButton.isEnabled = false
            topTextField.text = defaultTextForTop
            bottomTextField.text = defaultTextForBottom
            imageView.image = nil
        }
    }
    
    fileprivate func showCamera() {
        
        let camera = UIImagePickerController()
        
        camera.delegate = self
        
        camera.allowsEditing = false
        
        camera.sourceType = UIImagePickerControllerSourceType.camera
        
        camera.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
        
        camera.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        present(camera, animated: true, completion: nil)
    }
    
    // Create a UIImage that combines the image view and the labels.
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        configureHiddenPropertyToolbarsAndNavbar(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        var memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Crop the image to the CGRect of the provided image
        if let cropedImage = memedImage.cgImage?.cropping(to: imageView.frame) {
            
            memedImage = UIImage(cgImage: cropedImage)
        }
        
        // Show toolbar and navbar
        configureHiddenPropertyToolbarsAndNavbar(false)
        
        return memedImage
    }
    
    
    
    func shareButtonAction() {
        
        pushViewBoolean = false
        
        // Generate a new memed image
        let meme = Meme(
            topText: (topTextField.text?.trim())!,
            bottomText: (bottomTextField.text?.trim())!,
            originalImage: imageView.image!,
            memedImaged: generateMemedImage()
        )
        
        // Add it to the memeas array on the Application Delegate
        (UIApplication.shared.delegate as? AppDelegate)?.memes.append(meme)
        
        let activityView = UIActivityViewController(activityItems: [meme.memedImaged], applicationActivities: nil)

        present(activityView, animated: true, completion: nil)
    }
    
    func cancelButtonAction() {
        
        dismiss(animated: true, completion: nil)
    }
    
    // http://stackoverflow.com/questions/27646107/how-to-check-if-the-user-gave-permission-to-use-the-camera
    func cameraButtonAction() {
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized {
            
            // Already Authorized
            showCamera()
            
        } else {
            
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                
                if granted == true {
                    
                    // User granted. Code because this block may be executed in a thread.
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        self.showCamera()
                    })
                    
                } else {
                    
                    // User Rejected
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                }
            });
        }
    }
    
    func albumButtonAction() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: UIImagePickerControllerDelegate
extension MemeEditorViewController: UIImagePickerControllerDelegate {
    
    // http://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            configureShareEnableState(true)
            
        } else {
            
            configureShareEnableState(false)
        }
        
        DispatchQueue.main.async { () -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        DispatchQueue.main.async { () -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: UITextFieldDelegate
extension MemeEditorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
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


