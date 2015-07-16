//
//  CustomCellConversas.swift
//  MidPoint
//
//  Created by William Alvelos on 16/07/15.
//  Copyright (c) 2015 FDJ. All rights reserved.
//

import UIKit
import Foundation

class CustomCellConversas: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var imageLabel: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
