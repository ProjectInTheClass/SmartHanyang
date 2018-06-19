//
//  WeekdayPicker.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 18..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class WeekdayPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource
{
    public var selectedWeekDay:Int = 0
    
    
    public func Select(weekDay:Int)
    {
        selectedWeekDay = weekDay
        self.selectRow(weekDay-1, inComponent: 0, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Easy.WeekdayToString(weekDay: row+1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWeekDay = row+1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        self.delegate = self
        self.dataSource = self
    }
}
