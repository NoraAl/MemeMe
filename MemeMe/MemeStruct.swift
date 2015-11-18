//
//  MemeStruct.swift
//  MemeMe
//
//  Created by Nora on 11/18/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit

struct Meme{
    var bottom, top: String
    var image, memedImage: UIImage
    
    init (top:String, bottom: String, image:
        UIImage, memedImage: UIImage){
            self.top = top
            self.bottom = bottom
            self.image = image
            self.memedImage = memedImage
    }
}