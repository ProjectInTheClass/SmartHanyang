//
//  EditSuupViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 15..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class EditSuupViewController: UIViewController
{
    @IBOutlet weak var bogangView: UIView!
    @IBOutlet weak var hygangView: UIView!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    @IBOutlet weak var typeSelector: UISegmentedControl!
    @IBOutlet weak var lecturePicker: LecturePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bogangStartTime: UIDatePicker!
    @IBOutlet weak var bogangEndTime: UIDatePicker!
    @IBOutlet weak var hyugangTimePicker: LectureTimePicker!
    @IBOutlet weak var bogangRoom: UITextField!
    
    enum Mode:Int{
        case HYUGANG = 0
        case BOGANG
    }
    var mode:Mode = .HYUGANG
    
    @IBAction func cancel()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done()
    {
        self.dismiss(animated: true) {
            let lecture_ = LectureDataManager.shared.GetLecture(id: self.lecturePicker.selectedLectureId)
            if lecture_ == nil
            {
                return
            }
            let lecture = lecture_!
            
            if self.mode == .HYUGANG
            {
                if let time = self.hyugangTimePicker.selectedTimeTable
                {
                    lecture.AddHyugang(date: self.datePicker.date, timeTable:time)
                    LectureDataManager.shared.Save()
                }
            }
            else if self.mode == .BOGANG
            {
                var cal = Calendar.current
                let date = self.datePicker.date
                cal.timeZone = .current
                var tttt1 = cal.dateComponents([.hour,.minute,.second], from: date)
                var t1:Int = 0, t2:Int = 0
                if let h = tttt1.hour , let m = tttt1.minute , let s = tttt1.second{
                    t1 = h*3600 + m*60 + s
                }
                if let h = tttt1.hour , let m = tttt1.minute , let s = tttt1.second{
                    t2 = h*3600 + m*60 + s
                }
                let weekday = cal.component(.weekday, from: date)
                if let bogangRoom = self.bogangRoom.text {
                    let bogang = LectureTimeTable(room: bogangRoom, lectureId: lecture.id, timeStart: t1, timeEnd: t2, weekDay: weekday, bogangDay: date, hyugangDays: [])
                    lecture.bogangTimeTables.append(bogang)
                    LectureDataManager.shared.Save()
                }
                else{
                    self.ShowAlert(title: "보강하는 방을 적어주세요!",message: "어디서 보강하죠?")
                    return
                }
                LectureDataManager.shared.Save()
            }
        }
    }
    
    @IBAction func typeChanged(sender:UISegmentedControl)
    {
        switch typeSelector.selectedSegmentIndex {
        case 0:
            ShowHyugangView()
            mode = .HYUGANG
            break
        case 1:
            ShowBogangView()
            mode = .BOGANG
            doneBtn.isEnabled = true
            break
        default:
            break
        }
    }
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        hyugangTimePicker.SetDate(date: sender.date)
    }
    
    public func ShowBogangView()
    {
        hygangView.isHidden = true
        bogangView.isHidden = false
        
    }
    
    public func ShowHyugangView()
    {
        hygangView.isHidden = false
        bogangView.isHidden = true
        
    }
    
    public func InitLecture(lectureId:Int = -1)
    {
        let lectures = LectureDataManager.shared.GetLectures()
        if lectures.count == 0
        {
            ShowAlert(title: "수업 정보가 없습니다! x_x",message: "먼저 수업을 추가해주세요~")
            return
        }
        if lectureId == -1
        {
            return
        }
        lecturePicker.select(lectureId: lectureId)
    }
    
    func OnLectureSelected(lectureId:Int)
    {
        if let lecture = LectureDataManager.shared.GetLecture(id: lectureId){
            hyugangTimePicker.SetLecture(lecture: lecture)
        }
    }
    
    func OnLectureTimeSelected(lectureTime:LectureTimeTable?)
    {
        if let time = lectureTime {
            doneBtn.isEnabled = true
        }
        else {
            doneBtn.isEnabled = false
        }
    }
    
    func ShowAlert(title:String, message:String)
    {
        let alertController = UIAlertController(title: "수업 정보가 없습니다! x_x",message: "먼저 수업을 추가해주세요~", preferredStyle: UIAlertControllerStyle.alert)
        
        //UIAlertActionStye.destructive 지정 글꼴 색상 변경
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            self.cancel()
        }
        alertController.addAction(okAction)
        self.present(alertController,animated: true,completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lecturePicker.addSelectListener(f: OnLectureSelected)
        hyugangTimePicker.AddPickListener(f: OnLectureTimeSelected)
        let id = lecturePicker.selectedLectureId
        if let lecture = LectureDataManager.shared.GetLecture(id: id){
            hyugangTimePicker.SetLecture(lecture: lecture)
        }
        hyugangTimePicker.SetDate(date: datePicker.date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
