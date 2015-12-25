//
//  MemeDataMdel.swift
//  MemeMe
//
//  Created by Nora on 12/25/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import Foundation


import UIKit

class Memes: NSObject, NSCoding {
    var top: String
    var bottom: String
    var memedImage: UIImage
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("memes")
    
    struct PropertyKey {
        static let topKey = "top"
        static let bottomKey = "bottom"
        static let memedImageKey = "memedImage"
    }
    
    init?(top: String, bottom: String, memedImage: UIImage) {
        // Initialize stored properties.
        self.top = top
        self.bottom = bottom
        self.memedImage = memedImage
        
        super.init()
}
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(top, forKey: PropertyKey.topKey)
        aCoder.encodeObject(memedImage, forKey: PropertyKey.memedImageKey)
        aCoder.encodeObject(bottom, forKey: PropertyKey.bottomKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let top = aDecoder.decodeObjectForKey(PropertyKey.topKey) as! String
        let bottom = aDecoder.decodeObjectForKey(PropertyKey.bottomKey) as! String
        let memedImage = aDecoder.decodeObjectForKey(PropertyKey.memedImageKey) as! UIImage
        
        self.init(top: top, bottom: bottom, memedImage: memedImage)
    }
    
}
// MARK: global array that holds all sent or saved memes
var allMemes = [Memes]()

// MARK: global save and load methods
func saveMemess() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allMemes, toFile: Memes.ArchiveURL.path!)
    if !isSuccessfulSave {
        print("Failed to save allMemes...")
    }
}

func loadMemess() -> [Memes]? {
    return NSKeyedUnarchiver.unarchiveObjectWithFile(Memes.ArchiveURL.path!) as? [Memes]
}

