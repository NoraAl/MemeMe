//
//  TableViewCell.swift
//  MemeMe
//
//  Created by Nora on 12/25/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit

class MemeTableCell: UITableViewCell {
    @IBOutlet weak var cellTopText: UILabel!
    @IBOutlet weak var cellBottomText: UILabel!
    @IBOutlet weak var cellDateText: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    let highlightedColor = UIColor(red:0.882, green:0.918, blue:0.937, alpha:1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = myBackgroundColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        backgroundColor = selected ? highlightedColor : myBackgroundColor

    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool){
        backgroundColor =  highlighted ? highlightedColor : myBackgroundColor
    }

}
