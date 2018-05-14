//
//  SuupTableViewCell.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 10..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class SuupTableViewCell: UITableViewCell {

    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var locationLabel: UILabel!
    @IBOutlet weak public var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
