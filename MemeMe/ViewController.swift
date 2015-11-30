//
//  ViewController.swift
//  MemeMe
//
//  Created by Nora on 11/17/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit


class ViewController: UIViewController{
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet var board: Board!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    let imagePickerDelegate = ImagePickerDelegate()
    let textFieldDelegate = TextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.enabled = false
        
        undoButton.shadow(undoButton)
        doneButton.shadow(doneButton)
        
        drawingView(shown: false)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        bottomTextField.defaultTextAttributes = TextField().memeTextAttributes
        topTextField.defaultTextAttributes = TextField().memeTextAttributes
        
        topTextField.delegate = textFieldDelegate
        bottomTextField.delegate = textFieldDelegate
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
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
        if  bottomTextIsBeingEdited{
            view.frame.origin.y -= getKeyboardHeight(notification)}
    }
    
    func keyboardWillHide(notification: NSNotification){
        if bottomTextIsBeingEdited {
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
        imagePickerDelegate.pickAnImage(fromLibrary: true, imageView: imageView, viewController: self,shareButton: shareButton)
    }
    
    @IBAction func cameraButton(sender: UIBarButtonItem) {
        imagePickerDelegate.pickAnImage(fromLibrary: false, imageView: imageView, viewController: self,shareButton: shareButton)
    }

    @IBAction func shareAction(sender: UIBarButtonItem) {
        let image = generateMemedImage()
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
        let meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: imageView.image!,board: board.takeImage(), memedImage: generateMemedImage())
        print("Meme object is saved:\n", meme)
    }
    
    func toggleBars(hide hide: Bool){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDelay(0.3)
        if (hide){
            topBar.alpha = 0
            bottomBar.alpha = 0
        } else {
            topBar.alpha = 1
            bottomBar.alpha = 1}
        UIView.commitAnimations()
    }
    
    @IBAction func doneAcrion(sender: UIButton) {
        drawingView(shown: false)
        toggleBars(hide: false)
        board.brush = nil
    }
    
    @IBAction func undoAction(sender: UIButton) {
        board.undo()
    }
    
    @IBAction func draw(sender: UIBarButtonItem) {
        toggleBars(hide: true)
        delay(0.4){
            self.drawingView(shown: true)
        }
        board.brush = PencilBrush()
        
        self.board.drawingStateChangedBlock = {(state: DrawingState) -> () in
            if state != .Moved {
                UIView.beginAnimations(nil, context: nil)
                if state == .Began {
                    self.undoButton.alpha = 0
                } else if state == .Ended {
                    UIView.setAnimationDelay(0.3)
                    self.undoButton.alpha = 1
                }
                UIView.commitAnimations()
            }
        }
    }
    
    func drawingView(shown shown: Bool){
        if shown {
            undoButton.enabled = true
            undoButton.hidden = false
            doneButton.enabled = true
            doneButton.hidden = false
        } else {
            undoButton.enabled = false
            undoButton.hidden = true
            doneButton.enabled = false
            doneButton.hidden = true
        }
    }
    
    func generateMemedImage() -> UIImage {
        toggleBars(hide: true)
        drawingView(shown: false)
        var memedImage = UIImage()
        // Render view to an image
        delay(0.7){
            UIGraphicsBeginImageContext(self.view.frame.size)
            self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
            memedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        toggleBars(hide: false)
        return memedImage
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}

