//
//  ViewController.swift
//  MemeMe
//
//  Created by Nora on 11/17/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit


class MemeEditorViewController: UIViewController{
    
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
    @IBOutlet weak var drawButton: UIBarButtonItem!
    
    let imagePickerDelegate = ImagePicker()
    let textFieldDelegate = TextField()
    var memedImage: UIImage?
    
    var newMeme: Memes?
    
    enum Views{
        case mainView(Bool)
        case boardView(Bool)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        topTextField.delegate = textFieldDelegate
        bottomTextField.delegate = textFieldDelegate
        
        undoButton.shadow()
        doneButton.shadow()
        
        bottomTextField.defaultTextAttributes = TextField().memeTextAttributes
        topTextField.defaultTextAttributes = TextField().memeTextAttributes
        
        show(.boardView(false))
        
        if let newMeme = self.newMeme {
            
            reconstructExistingMeme(newMeme)
        } else {
            shareButton.enabled = false
            drawButton.enabled = false
            
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
        }
    }
    
    func reconstructExistingMeme(existingMeme: Memes){
        topTextField.text = existingMeme.top
        bottomTextField.text = existingMeme.bottom
        imageView.image = existingMeme.originalImage
        board = existingMeme.board
        
        view.bringSubviewToFront(board)
        
        shareButton.enabled = true
        drawButton.enabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
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
        imagePickerDelegate.pickAnImage(fromLibrary: true, imageView: imageView, viewController: self,shareButton: shareButton, drawButton:drawButton)
    }
    
    @IBAction func cameraButton(sender: UIBarButtonItem) {
        imagePickerDelegate.pickAnImage(fromLibrary: false, imageView: imageView, viewController: self,shareButton: shareButton, drawButton:drawButton)
    }

    @IBAction func shareAction(sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let shareViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        presentViewController(shareViewController, animated: true, completion: nil)
        shareViewController.completionWithItemsHandler = { (_:String?, completed:Bool, _:[AnyObject]?, error:NSError?)->Void in
            if completed {
                self.save()
                self.performSegueWithIdentifier("dismissMemeEditor", sender: self)
                //shareViewController.dismissViewControllerAnimated(true, completion: nil )
            }
            if let error = error {
                print("\(error)")
            }
        }
    }
    
    @IBAction func undoAction(sender: UIButton) {
        board.undo()
    }
    
    @IBAction func doneAction(sender: UIButton) {
        show(.boardView(false))
        show(.mainView(true))
        board.brush = nil
    }
    
    @IBAction func draw(sender: UIBarButtonItem) {
        show(.mainView(false))
        show(.boardView(true))
        
        view.bringSubviewToFront(board)
        view.bringSubviewToFront(topBar)
        view.bringSubviewToFront(bottomBar)
        
        board.brush = PencilBrush()
        
        board.drawingStateChangedBlock = {(state: DrawingState) -> () in
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
    
    func generateMemedImage() -> UIImage {
        show(.mainView(false))
        show(.boardView(false))
        
        var memedImage = UIImage()
        
        // Render view to an image
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        show(.mainView(true))
        return memedImage
    }
    
    func show(view : Views){
        func boardView(alpha: CGFloat){
            undoButton.alpha = alpha
            doneButton.alpha = alpha
        }
        
        func mainView(alpha: CGFloat){
            topBar.alpha = alpha
            bottomBar.alpha = alpha
        }
        
        switch view{
        case let .boardView(show):
            boardView(show ? 1 : 0)
        case let .mainView(show):
            mainView(show ? 1 : 0)
        }
    }
    
    func save(){
        newMeme = Memes(top: self.topTextField.text!, bottom: self.bottomTextField.text!, originalImage: imageView.image!, board: self.board, memedImage: memedImage!)
    }
    
}

