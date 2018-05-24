//
//  GoajaeTableViewCell.swift
//  SmartHanYang
//
//  Created by 현경우 on 2018. 5. 21..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class GoajaeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
