//
//  LectureTimePicker.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 15..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class LectureTimePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource
{
    var lecture:Lecture?
    var times:[LectureTimeTable] = []
    var weekDay:Int = -1
    
    public func SetLecture(lecture:Lecture)
    {
        self.lecture = lecture
        UpdateTimes()
    }
    
    public func SetDate(date:Date)
    {
        var cal = Calendar.current
        cal.timeZone = .current
        
        weekDay = cal.component(.day, from: Date())
        UpdateTimes()
    }
    
    func UpdateTimes()
    {
        if let lecture = lecture
        {
            times = lecture.timeTables.filter({ (t) -> Bool in
                return t.weekDay == self.weekDay
            })
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if times.count == 0
        {
            return 1
        }
        return times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if times.count == 0
        {
            return "수업 없음"
        }
        return times[row].GetTimeText()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    

}
