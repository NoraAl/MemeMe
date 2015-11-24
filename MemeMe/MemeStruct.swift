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
    var image, board, memedImage: UIImage
    
    init (top:String, bottom: String, image:
        UIImage,board: UIImage, memedImage: UIImage){
            self.top = top
            self.bottom = bottom
            self.image = image
            self.board = board
            self.memedImage = memedImage
    }
}