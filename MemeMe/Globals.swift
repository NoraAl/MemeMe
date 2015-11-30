//
//  MemeStruct.swift
//  MemeMe
//
//  Created by Nora on 11/18/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit

var bottomTextIsBeingEdited : Bool = false
var moveViewUp:Bool {
set {
    bottomTextIsBeingEdited = newValue
}
get {
    return bottomTextIsBeingEdited
}
}

extension UIButton{
    func shadow(button:UIButton){
        button.layer.shadowRadius  = 0.65
        button.layer.shadowOffset = CGSize(width: 3, height: 0)
        button.layer.shadowOpacity = 0.85
        button.layer.shadowColor = UIColor.whiteColor().CGColor
    }
}

extension NSParagraphStyle {
    func centerParagraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        return paragraphStyle.copy() as! NSParagraphStyle
    }
}

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