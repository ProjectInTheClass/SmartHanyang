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
    @IBOutlet weak public var hyugangLabel: UILabel!
    @IBOutlet weak public var progressBar: UIProgressView!
    
    var timeTable:LectureTimeTable?
    var defaultColor:UIColor?
    var isHyugang = false
    
    public func SetTimeTable(table:LectureTimeTable)
    {
        self.timeTable = table
        defaultColor = progressBar.tintColor
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
        
        hyugangLabel.isHidden = true
        isHyugang = false
        for day in table.hyugangDays
        {
            if EasyCalendar.isToday(date: day) {
                hyugangLabel.isHidden = false
                hyugangLabel.textColor = .red
                hyugangLabel.text = "휴강"
                isHyugang = true
                break
            }
        }
        if table.bogangDay != nil {
            hyugangLabel.isHidden = false
            hyugangLabel.textColor = .blue
            hyugangLabel.text = "보강"
        }
        
        Update()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.Update), userInfo: nil, repeats: true)
    }
    
    @objc func Update()
    {
        if timeTable == nil{
            return
        }
        let table:LectureTimeTable! = timeTable
        
        var cal = Calendar.current
        cal.timeZone = .current
        let c = cal.dateComponents([.hour,.minute,.second], from: Date())
        
        let t = c.second! + c.minute! * 60 + c.hour! * 3600
        
        if t < table.timeStart{
            progressBar.progress = 0
        }
        else if t > table.timeEnd{
            progressBar.progress = 0
            
            titleLabel.isEnabled = false
            locationLabel.isEnabled = false
            timeLabel.isEnabled = false
            hyugangLabel.isEnabled = false
        }
        else{
            progressBar.tintColor = defaultColor
            progressBar.progress = Float(t-table.timeStart)/Float(table.timeEnd-table.timeStart)
            
            titleLabel.isEnabled = true
            locationLabel.isEnabled = true
            timeLabel.isEnabled = true
            hyugangLabel.isEnabled = true
        }
        
        if isHyugang {
            progressBar.tintColor = UIColor.black
            
            titleLabel.isEnabled = false
            locationLabel.isEnabled = false
            timeLabel.isEnabled = false
        }
        else {
            progressBar.tintColor = defaultColor
            
            titleLabel.isEnabled = true
            locationLabel.isEnabled = true
            timeLabel.isEnabled = true
        }
    }
}
