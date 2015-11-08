//
//  MessageTableViewCell.swift
//  LifeRaft
//
//  Created by Sam Ginsburg on 11/7/15.
//  Copyright © 2015 sbg11. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    let myMess = MessagesViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
             // Configure the view for the selected state
    }

}
