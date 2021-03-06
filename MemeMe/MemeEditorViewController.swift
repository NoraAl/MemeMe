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
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
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
        board.image = existingMeme.board.image
        
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
        if  bottomTextIsBeingEdited {
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
        shareViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                self.save()
                self.performSegueWithIdentifier("dismissMemeEditor", sender: self)
            } else {
                self.newMeme = nil// if comes from existing meme, don't add it
                self.performSegueWithIdentifier("dismissMemeEditor", sender: self)
            }
            if let activityError = activityError {
                print("\(activityError)")
            }
        }
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func undoAction(sender: UIButton) {
        board.undo()
    }
    
    @IBAction func doneAction(sender: UIButton) {
        show(.boardView(false))
        show(.mainView(true))
        board.brush = nil
        view.bringSubviewToFront(topBar)
        view.bringSubviewToFront(bottomBar)
    }
    
    @IBAction func draw(sender: UIBarButtonItem) {
        show(.mainView(false))
        show(.boardView(true))
        
        view.bringSubviewToFront(board)
        
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
        var memedImage = UIImage()
        let virtualView = self.virtualView()
        
        UIGraphicsBeginImageContextWithOptions(virtualView.frame.size, false, 0)
        
        virtualView.drawViewHierarchyInRect(virtualView.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

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
        let currentTime = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)

        newMeme = Memes(top: topTextField.text!, bottom: bottomTextField.text!, originalImage: imageView.image!, board: board, memedImage: memedImage!,time: currentTime)
    }
    
}

extension MemeEditorViewController
{
    func virtualView() -> UIView{
        
        let virtualView = UIView(frame: view.frame)
        virtualView.backgroundColor = view.backgroundColor
        
        let virtualImageView = UIImageView(frame: imageView.frame)
        virtualImageView.contentMode = .ScaleAspectFit
        virtualImageView.image = imageView.image
        
        let virtualTop = UITextField(frame: topTextField.frame)
        virtualTop.defaultTextAttributes = topTextField.defaultTextAttributes
        virtualTop.text = topTextField.text
        
        let virtualBottom = UITextField(frame: bottomTextField.frame)
        virtualBottom.defaultTextAttributes = bottomTextField.defaultTextAttributes
        virtualBottom.text = bottomTextField.text
        
        let virtualBoard = UIImageView(image: board.image)
        
        virtualView.addSubview(virtualImageView)
        virtualView.addSubview(virtualBoard)
        virtualView.addSubview(virtualTop)
        virtualView.addSubview(virtualBottom)
        
        return virtualView
    }

}

extension UIActivityViewController{
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }

}
