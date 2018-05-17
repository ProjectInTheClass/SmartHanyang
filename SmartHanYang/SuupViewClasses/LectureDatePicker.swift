//
//  LectureDatePicker.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 16..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class LectureDatePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var lecture:Lecture?
    var days:[Date] = []
    var weekDays:[Int] = []
    
    public func SetLecture(lecture:Lecture)
    {
        self.lecture = lecture
        weekDays.removeAll()
        for t in lecture.timeTables{
            if let weekDay = t.weekDay{
                weekDays.append(weekDay)
            }
        }
        days.removeAll()
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        self.delegate = self
        self.dataSource = self
    }
}
