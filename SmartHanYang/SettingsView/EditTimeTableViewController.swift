//
//  EditTimeTableViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 18..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class EditTimeTableViewController: UITableViewController {
    @IBOutlet var roomLabel:UITextField!
    @IBOutlet var twoTimePicker:TwoTimePicker!
    @IBOutlet var weekdayPicker:WeekdayPicker!
    
    var timeTable:LectureTimeTable?
    var lecture:Lecture?
    
    public var loadFunc:(()->Void)?;
    
    @IBAction func Save()
    {
        self.navigationController?.popViewController(animated: true)
        if let lec = lecture, let t = timeTable {
            
            t.room = roomLabel.text ?? ""
            t.timeStart = twoTimePicker.selectedTimeStart
            t.timeEnd = twoTimePicker.selectedTimeEnd
            t.weekDay = weekdayPicker.selectedWeekDay
            
            if !lec.timeTables.contains(t)
            {
                t.lectureId = lec.id
                lec.timeTables.append(t)
            }
            LectureDataManager.shared.Save()
        }
    }
    
    public func Set(lecture:Lecture)
    {
        self.lecture = lecture
    }
    
    public func Set(lectureTimeTable:LectureTimeTable)
    {
        self.timeTable = lectureTimeTable
        if let t = timeTable {
            roomLabel.text = t.room
            twoTimePicker.Select(timeStart: t.timeStart, timeEnd: t.timeEnd)
            if t.weekDay != nil {
                weekdayPicker.Select(weekDay: t.weekDay!)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return timeTable?.lectureId == lecture?.id ? 4 : 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            Easy.ShowAlert(me: self, title: "정말 수업을 삭제하시겠습니까?", message: "") { (b) in
                if b{
                    self.lecture!.timeTables.remove(at: indexPath.row)
                    LectureDataManager.shared.Save(dispatch: false)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFunc?()
    }


}
