//
//  ViewController.swift
//  MemeMe
//
//  Created by Nora on 11/17/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit
var framWidth :CGFloat = 0.0
var bottomTextFieldIsBeingEdited = false

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    let textFieldDelegate = TextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.enabled = false
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        bottomTextField.defaultTextAttributes = TextField().memeTextAttributes
        topTextField.defaultTextAttributes = TextField().memeTextAttributes
        
        topTextField.delegate = textFieldDelegate
        bottomTextField.delegate = textFieldDelegate
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        framWidth = self.view.frame.maxX
    }
    
    override func viewWillAppear(animated: Bool) {
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
    }
    
    func keyboardWillShow(notification: NSNotification){
        if bottomTextFieldIsBeingEdited {
            view.frame.origin.y -= getKeyboardHeight(notification)}
    }
    
    func keyboardWillHide(notification: NSNotification){
        if bottomTextFieldIsBeingEdited {
            view.frame.origin.y += getKeyboardHeight(notification)}
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func libraryButton(sender: UIBarButtonItem) {
        pickAnImage(fromLibrary: true)
    }
    
    @IBAction func cameraButton(sender: UIBarButtonItem) {
        pickAnImage(fromLibrary: false)
    }

    func pickAnImage(fromLibrary fromLibrary: Bool) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        
        if(fromLibrary){
            imagePickerViewController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        else {
            imagePickerViewController.sourceType = UIImagePickerControllerSourceType.Camera
        }
        presentViewController(imagePickerViewController, animated: true, completion: nil)
    }
    
    //imagePickerViewController delegate mehtods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.enabled = true
        }
        else { print("image cannot be selected properly") }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func shareAction(sender: UIBarButtonItem) {let image = generateMemedImage()
        let shareViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(shareViewController, animated: true, completion: nil)
        
        shareViewController.completionWithItemsHandler = { (a:String?, completed:Bool, r:[AnyObject]?, d:NSError?)->Void in
            if(completed){
                self.save()
                shareViewController.dismissViewControllerAnimated(true, completion: nil )
            } else {
                print("Sharing is canceled.")
            }
            
        }
    }
    
    func save() {
        
        let meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: imageView.image!, memedImage: generateMemedImage())
        print("Meme object is saved:\n", meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        topBar.hidden = true
        bottomBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topBar.hidden = false
        bottomBar.hidden = false
        
        return memedImage
    }
}