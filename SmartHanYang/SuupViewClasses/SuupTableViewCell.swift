//
//  SuupTableViewCell.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 10..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class SuupTableViewCell: UITableViewCell
{
    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var locationLabel: UILabel!
    @IBOutlet weak public var timeLabel: UILabel!
    @IBOutlet weak public var progressBar: UIProgressView!
    
    var timeTable:LectureTimeTable?
    
    public func SetTimeTable(table:LectureTimeTable)
    {
        self.timeTable = table
        if let lecture = LectureDataManager.shared.GetLecture(id: table.lectureId)
        {
            titleLabel.text = lecture.name
        }
        else
        {
            titleLabel.text = "알 수 없는 수업"
        }
        timeLabel.text = table.GetTimeText()
        locationLabel.text = table.room
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
