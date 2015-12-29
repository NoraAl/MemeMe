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
    var bottom, top, time: String
    var originalImage, memedImage: UIImage
    var board: Board
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("memes")
    
    struct PropertyKey {
        static let topKey = "top"
        static let bottomKey = "bottom"
        static let originalImage = "originalImage"
        static let memedImageKey = "memedImage"
        static let boardKey = "boardKey"
        static let timeKey = "timeKey"
    }
    
    init?(top: String, bottom: String, originalImage: UIImage, board: Board, memedImage: UIImage, time: String) {
        // Initialize stored properties.
        self.top = top
        self.bottom = bottom
        self.memedImage = memedImage
        self.originalImage = originalImage
        self.board = board
        self.time = time
        
        super.init()
}
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(top, forKey: PropertyKey.topKey)
        aCoder.encodeObject(bottom, forKey: PropertyKey.bottomKey)
        aCoder.encodeObject(originalImage, forKey:  PropertyKey.originalImage)
        aCoder.encodeObject(board, forKey: PropertyKey.boardKey)
        aCoder.encodeObject(memedImage, forKey: PropertyKey.memedImageKey)
        aCoder.encodeObject(time, forKey: PropertyKey.timeKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let top = aDecoder.decodeObjectForKey(PropertyKey.topKey) as! String
        let bottom = aDecoder.decodeObjectForKey(PropertyKey.bottomKey) as! String
        let originalImage = aDecoder.decodeObjectForKey(PropertyKey.originalImage) as! UIImage
        let board = aDecoder.decodeObjectForKey(PropertyKey.boardKey) as! Board
        let memedImage = aDecoder.decodeObjectForKey(PropertyKey.memedImageKey) as! UIImage
        let time = aDecoder.decodeObjectForKey(PropertyKey.timeKey) as! String
        
        self.init(top: top, bottom: bottom, originalImage: originalImage, board: board, memedImage: memedImage, time:time)
    }
    
}