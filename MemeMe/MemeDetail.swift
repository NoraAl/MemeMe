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
    
    override func viewDidLoad() {
        if let memedImage = self.memedImage {
            detailViewImage.image = memedImage
        } else {
            print("Why did I allow sharing?!")
        }
        super.viewDidLoad()
    }
}