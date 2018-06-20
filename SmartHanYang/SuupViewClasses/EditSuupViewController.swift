//
//  EditSuupViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 15..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class EditSuupViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var bogangView: UIView!
    @IBOutlet weak var hygangView: UIView!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    @IBOutlet weak var typeSelector: UISegmentedControl!
    @IBOutlet weak var lecturePicker: LecturePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bogangTimePicker:TwoTimePicker!
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
        var dismissOk = true
        
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
            var t1 = bogangTimePicker.selectedTimeStart
            var t2 = bogangTimePicker.selectedTimeEnd
            
            if t2 <= t1
            {
                Easy.ShowAlert(me:self ,title: "아니 이건 좀..", message: "질리언이세요?")
                return
            }
            
            let weekday = EasyCalendar.GetWeekday(date: self.datePicker.date)
            let bogangRoom = self.bogangRoom.text
            if bogangRoom != nil && bogangRoom!.count > 0  {
                let bogang = LectureTimeTable(room: bogangRoom!, lectureId: lecture.id, timeStart: t1, timeEnd: t2, weekDay: weekday, bogangDay: self.datePicker.date, hyugangDays: [])
                
                let lectures = LectureDataManager.shared.GetLectures()
                var alreadyLectureExist = false
                for lecture in lectures {
                    for t in lecture.timeTables{
                        if weekday == t.weekDay{
                            continue
                        }
                        //혹시 휴강인것인지 체크
                        var isHyugangDay = false
                        for d in t.hyugangDays{
                            if EasyCalendar.IsSameDay(date1: d, date2: self.datePicker.date) {
                                isHyugangDay = true
                            }
                        }
                        if isHyugangDay{
                            continue
                        }
                        //-----------------
                        
                        //시간 충돌이 있나 체크
                        let clash1 = t.timeStart < t1 && t1 < t.timeEnd;
                        let clash2 = t.timeStart < t2 && t2 < t.timeEnd;
                        let clash3 = t1 < t.timeStart && t.timeStart < t2;
                        let clash4 = t1 < t.timeEnd && t.timeEnd < t2;
                        
                        if clash1 || clash2 || clash3 || clash4
                        {
                            alreadyLectureExist = true
                            break
                        }
                        //-----------------
                    }
                    if alreadyLectureExist{
                        break;
                    }
                }
                if alreadyLectureExist{
                    dismissOk = false
                    Easy.ShowAlert(me:self, title: "해당 기간에 다른 수업 있음", message: "그래도 추가할거임?", f: {(ok:Bool) in
                        if ok{
                            self.dismiss(animated: true)
                            lecture.bogangTimeTables.append(bogang)
                            LectureDataManager.shared.Save()
                        }
                        else
                        {
                            dismissOk = false
                        }
                    })
                }
                else{
                    self.dismiss(animated: true)
                    lecture.bogangTimeTables.append(bogang)
                    LectureDataManager.shared.Save()
                }
            }
            else{
                Easy.ShowAlert(me:self, title: "보강하는 방을 적어주세요!",message: "어디서 보강하죠?")
                dismissOk = false
            }
        }
        if dismissOk{
            self.dismiss(animated: true)
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
    
    func OnLectureSelected(lectureId:Int)
    {
        if let lecture = LectureDataManager.shared.GetLecture(id: lectureId){
            hyugangTimePicker.SetLecture(lecture: lecture)
        }
    }
    
    func OnLectureTimeSelected(lectureTime:LectureTimeTable?)
    {
        if lectureTime != nil {
            doneBtn.isEnabled = true
        }
        else {
            doneBtn.isEnabled = false
        }
    }
    
    func ShowAlert(title:String, message:String, f:((Bool)->Void)?=nil)
    {
        let alertController = UIAlertController(title: title,message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //UIAlertActionStye.destructive 지정 글꼴 색상 변경
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            if let ff = f
            {
                ff(true)
            }
        }
        alertController.addAction(okAction)
        if let ff = f
        {
            let noAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
                ff(false)
            }
            alertController.addAction(noAction)
        }
        self.present(alertController,animated: true,completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 150)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 150)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        /*
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        let rect = self.view.frame
        rect.offsetBy(dx: 0, dy: movement)
        self.view.frame = rect
        UIView.commitAnimations()
        */
        UIView.animate(withDuration: movementDuration, animations: { () -> Void in
            self.view.frame.origin.y += movement
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        bogangRoom.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
