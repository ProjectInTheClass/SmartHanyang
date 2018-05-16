//
//  HyugangCell.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 14..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit
import SpriteKit

class GonggangCell: UITableViewCell
{
    @IBOutlet weak public var label: UILabel!
    @IBOutlet weak public var progressBar: UIProgressView!
    var defaultColor:UIColor?
    
    public func SetHyugangInfor(time1:LectureTimeTable, time2:LectureTimeTable)
    {
        defaultColor = progressBar.tintColor
        let timeGap:Int = time2.timeStart - time1.timeEnd
        var str:String = "공강"
        if timeGap > 3600
        {
            str.append(" \(String(format:"%i",timeGap/3600))시간")
        }
        if timeGap%3600 != 0
        {
            str.append(" \(String(format:"%i",(timeGap%3600)/60))분")
        }
        label.text = str
        
        
        var cal = Calendar.current
        cal.timeZone = .current
        let c = cal.dateComponents([.hour,.minute,.second], from: Date())
        
        let t = c.second! + c.minute! * 60 + c.hour! * 3600
        
        if t < time1.timeEnd{
            progressBar.progress = 0
            label.isEnabled = true
        }
        else if t > time2.timeStart{
            progressBar.progress = 1
            label.isEnabled = false
            progressBar.tintColor = .gray
        }
        else{
            label.isEnabled = true
            progressBar.tintColor = defaultColor
            progressBar.progress = Float(t-time1.timeEnd)/Float(time2.timeStart-time1.timeEnd)
        }
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
