//
//  MessageCeelTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Veekay Infotech on 04/03/21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class MessageCeelTableViewCell: UITableViewCell {

    
    @IBOutlet weak var messgaeBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messgaeBubble.layer.cornerRadius = messgaeBubble.frame.size.height / 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
