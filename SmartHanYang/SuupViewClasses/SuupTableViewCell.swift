//
//  SuupTableViewCell.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 10..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class SuupTableViewCell: UITableViewCell {

    @IBOutlet weak public var suupTitle: UILabel!
    @IBOutlet weak public var suupTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
