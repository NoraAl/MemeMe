//
//  CollectionViewCell.swift
//  MemeMe
//
//  Created by Nora on 12/26/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.autoresizingMask = [.FlexibleWidth , .FlexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
 
        backgroundColor = myBackgroundColor
    }
}
