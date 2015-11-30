//
//  ImagePickerDelegate.swift
//  MemeMe
//
//  Created by Nora on 11/22/15.
//  Copyright © 2015 Nora. All rights reserved.
//


import UIKit

protocol ImagePickerProtocol{
    func pickAnImage(fromLibrary fromLibrary: Bool, imageView: UIImageView, viewController:UIViewController, shareButton:UIBarButtonItem)
}

class ImagePickerDelegate:  NSObject, ImagePickerProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var imageView = UIImageView()
    var shareButton = UIBarButtonItem()
    
    func pickAnImage(fromLibrary fromLibrary: Bool, imageView: UIImageView, viewController :UIViewController, shareButton:UIBarButtonItem){
        self.imageView = imageView
        self.shareButton = shareButton
        
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        
        if(fromLibrary){
            imagePickerViewController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        } else {
            imagePickerViewController.sourceType = UIImagePickerControllerSourceType.Camera
        }
        viewController.presentViewController(imagePickerViewController, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate mehtods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.enabled = true
        }
        else { print("image cannot be selected properly") }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}