//
//  TableViewCell.swift
//  MemeMe
//
//  Created by Nora on 12/25/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit

class MemeTableCell: UITableViewCell {
//@IBOutlet weak var cellT: UILabel!
    @IBOutlet weak var cellTopText: UILabel!
    @IBOutlet weak var cellBottomText: UILabel!
    @IBOutlet weak var cellDateText: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
