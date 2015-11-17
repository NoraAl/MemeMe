//
//  ViewController.swift
//  MemeMe
//
//  Created by Nora on 11/17/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    
    
    @IBAction func libraryButton(sender: UIBarButtonItem) {
        pickAnImage(fromLibrary: true)
    }
    
    @IBAction func cameraButton(sender: UIBarButtonItem) {
        pickAnImage(fromLibrary: false)
    }

    @IBAction func shareButton(sender: UIBarButtonItem) {
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
        else {
            
            print("image cannot be selected properly")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }

}