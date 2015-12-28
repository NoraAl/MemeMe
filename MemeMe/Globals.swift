//
//  MemeStruct.swift
//  MemeMe
//
//  Created by Nora on 11/18/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit

let myBackgroundColor = UIColor(red: 0.753, green:0.839, blue:0.894, alpha:1)

var bottomTextIsBeingEdited = false
var moveViewUp:Bool {
set { bottomTextIsBeingEdited = newValue }
get { return bottomTextIsBeingEdited }
}

extension UIButton{
    func shadow(){
        self.layer.shadowRadius  = 0.65
        self.layer.shadowOffset = CGSize(width: 3, height: 0)
        self.layer.shadowOpacity = 0.85
        self.layer.shadowColor = UIColor.whiteColor().CGColor
    }
}

extension NSParagraphStyle {
    func centerParagraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        return paragraphStyle.copy() as! NSParagraphStyle
    }
}


// MARK: global array that holds all sent or saved memes
var allMemes = [Memes]()

// MARK: global save and load methods
func saveAllMemes() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allMemes, toFile: Memes.ArchiveURL.path!)
    if !isSuccessfulSave {
        print("Failed to save allMemes...")
    }
}

func loadMemess() -> [Memes]? {
    /* //reset persistent Data"
    allMemes.removeAll()
    NSKeyedArchiver.archiveRootObject(allMemes, toFile: Memes.ArchiveURL.path!)
    */
    return NSKeyedUnarchiver.unarchiveObjectWithFile(Memes.ArchiveURL.path!) as? [Memes]
}

