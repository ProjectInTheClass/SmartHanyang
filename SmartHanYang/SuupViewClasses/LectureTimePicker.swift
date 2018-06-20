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
    public var selectedTimeTable:LectureTimeTable? = nil
    var lecture:Lecture?
    var times:[LectureTimeTable] = []
    var weekDay:Int = -1
    var listeners:[(LectureTimeTable?)->Void] = []
    
    public func AddPickListener(f:@escaping (LectureTimeTable?)->Void)
    {
        listeners.append(f)
    }
    
    public func SetLecture(lecture:Lecture)
    {
        self.lecture = lecture
        UpdateTimes()
    }
    
    public func SetDate(date:Date)
    {
        var cal = Calendar.current
        cal.timeZone = .current
        
        weekDay = cal.component(.weekday, from: date)
        UpdateTimes()
    }
    
    func UpdateTimes()
    {
        if let lecture = lecture
        {
            times = lecture.timeTables.filter({ (t) -> Bool in
                return t.weekDay == self.weekDay
            })
            reloadAllComponents()
        }
        selectRow(row: 0)
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
            selectedTimeTable = nil
            return "수업 없음"
        }
        return times[row].GetTimeText()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow(row: row)
    }
    
    func selectRow(row:Int)
    {
        if times.count == 0
        {
            selectedTimeTable = nil
        }
        else
        {
            selectedTimeTable = times[row]
        }
        for f in listeners {
            f(selectedTimeTable)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        self.delegate = self
        self.dataSource = self
        UpdateTimes()
    }
}
