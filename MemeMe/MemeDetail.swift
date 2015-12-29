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
    var memeDetail: Memes!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memeDetail = self.memeDetail {
            detailViewImage.image = memeDetail.memedImage
        }
    }
    override func shouldAutorotate() -> Bool {
        return true    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }

    @IBAction func editCurrentMeme(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorController = storyboard.instantiateViewControllerWithIdentifier("MemeEditorController") as! MemeEditorViewController
        memeEditorController.newMeme = memeDetail
        
        presentViewController(memeEditorController, animated: true, completion: nil)
    }
}