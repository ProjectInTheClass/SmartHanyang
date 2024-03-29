//
//  LecturePicker.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 15..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class LecturePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public var selectedLectureId:Int = -1
    
    var lectures:[Lecture] = []
    var listeners:[(Int)->Void] = []
    
    public func select(lectureId:Int) {
        var index = 0
        for (i, l) in lectures.enumerated()
        {
            if l.id == lectureId
            {
                index = i
            }
        }
        self.selectRow(index, inComponent: 0, animated: true)
        
    }
    
    public func addSelectListener(f:@escaping (Int)->Void)
    {
        listeners.append(f)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lectures.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lectures[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLectureId = lectures[row].id
        dispatchEvent()
    }
    
    func dispatchEvent()
    {
        for f in listeners{
            f(selectedLectureId)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        lectures = LectureDataManager.shared.GetLectures()
        if lectures.count > 0{
            selectedLectureId = lectures[0].id
        }
        self.delegate = self
        self.dataSource = self
    }
}
