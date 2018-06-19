//
//  TwoTimePicker.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 18..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class TwoTimePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource
{
    public var selectedTimeStart:Int = 0
    public var selectedTimeEnd:Int = 0
    
    public func Select(timeStart:Int, timeEnd:Int)
    {
        selectedTimeStart = timeStart
        selectedTimeEnd = timeEnd
        self.selectRow(Int(floor(Double(timeStart)/1800)), inComponent: 1, animated: false)
        self.selectRow(Int(floor(Double(timeEnd)/1800)), inComponent: 3, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component%2 == 0 {
            return 1
        }
        
        return 48
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return "시작"
        }
        else if component == 2 {
            return "끝"
        }
        return Easy.TimeToText(time: row*1800, blank: 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let time = row * 1800
        if component == 1 {
            selectedTimeStart = time
            if time > selectedTimeEnd {
                self.selectRow(row, inComponent: 3, animated: true)
                selectedTimeEnd = time
            }
        }
        else if component == 3{
            selectedTimeEnd = time
            if time < selectedTimeStart {
                self.selectRow(row, inComponent: 1, animated: true)
                selectedTimeStart = time
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component%2 == 0 {
            return 50
        }
        else {
            return 90
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        self.delegate = self
        self.dataSource = self
    }
}
