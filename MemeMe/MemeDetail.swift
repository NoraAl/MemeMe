//
//  MemeDetail.swift
//  MemeMe
//
//  Created by Nora on 12/25/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit


class MemeDetail: UIViewController{
    
    @IBOutlet weak var detailViewImage: UIImageView!
    var memedImage: UIImage!
    var memeDetail: Memes!
    
    override func viewDidLoad() {
        
        if let memeDetail = self.memeDetail {
            detailViewImage.image = memeDetail.memedImage
        } else {
            print("Why did I allow sharing?!")
        }
        super.viewDidLoad()
    }

    @IBAction func editCurrentMeme(sender: UIBarButtonItem) {
        
        var memeEditorController: MemeEditorViewController
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        memeEditorController = storyboard.instantiateViewControllerWithIdentifier("MemeEditorController") as! MemeEditorViewController
        memeEditorController.newMeme = memeDetail
        presentViewController(memeEditorController, animated: true, completion: nil)
    }
}