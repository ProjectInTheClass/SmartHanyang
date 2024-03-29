//
//  TimeTable.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 24..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class TimeTableView: UITableViewCell
{
    
    @IBOutlet weak var col0: UIStackView!
    @IBOutlet weak var col1: TimeTableViewCol!
    @IBOutlet weak var col2: TimeTableViewCol!
    @IBOutlet weak var col3: TimeTableViewCol!
    @IBOutlet weak var col4: TimeTableViewCol!
    @IBOutlet weak var col5: TimeTableViewCol!
    
    
    fileprivate static let TOP_HEIGHT = 20
    
    
    var cols:[TimeTableViewCol] = []
    var weekLectures:[[LectureTimeTable]] = []
    
    public func DoIt()
    {
        
        var startT = 3600*24
        var endT = 0
        
        let width = ceil(1.14*UIScreen.main.bounds.width / 6)
        let width0 = ceil(0.3*UIScreen.main.bounds.width / 6)
        
        var f = col0.frame
        f = CGRect(x: 0, y: f.minY, width: width0, height: f.height)
        col0.frame = f
        
        let today = EasyCalendar.GetDateFromToday()
        let todayComs = EasyCalendar.GetAllComponents(date: today)
        for (i,col) in cols.enumerated() {
            f = col.frame
            f = CGRect(x: 1+width0+width*CGFloat(i), y: f.minY, width: width-1, height: f.height)
            col.frame = f
            col.backgroundColor = UIColor.white
            col.subviews.forEach { view in
                view.removeFromSuperview()
            }
            
            let thisWeekDay = i+2
            let plusDay = (thisWeekDay-todayComs.weekday!+7)%7
            
            col.SetDate(date: EasyCalendar.GetDateFromToday(day: plusDay))
            col.AddWeekDayLabel(width: width)
            weekLectures.append(col.timeTables)
            
            for time in col.timeTables {
                startT = min(startT, time.timeStart)
                endT = max(endT, time.timeEnd)
            }
        }
        
        let goodStartT = startT - startT%3600
        let goodEndT = (endT%3600 == 0) ? endT : endT-endT%3600 + 3600
        let rowCount = Int((goodEndT - goodStartT)/3600)
        
        let contentHeight = self.frame.height - CGFloat(TimeTableView.TOP_HEIGHT)
        let cellHourHeight = ceil(CGFloat(contentHeight / CGFloat(rowCount)))-1
        
        for col in cols {
            col.Go(width:width,hourHeight:cellHourHeight, minTime: goodStartT, maxTime: goodEndT)
        }
        
        InitCol0(startT: goodStartT, endT: goodEndT, width:width0, hourHeight: cellHourHeight)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cols.append(col1)
        cols.append(col2)
        cols.append(col3)
        cols.append(col4)
        cols.append(col5)
        
        
    }
    
    func InitCol0(startT:Int, endT:Int, width:CGFloat, hourHeight:CGFloat)
    {
        col0.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        let rowCount = max(1,Int((endT - startT)/3600))
        let w = Int(width)
        
        let view = UIView(frame:CGRect(x: 0, y: 1, width: w, height:TimeTableView.TOP_HEIGHT-1))
        view.backgroundColor = UIColor.white
        col0.addSubview(view)
        
        for i in 0...(rowCount-1) {
            let view = UIView(frame:CGRect(x: 0, y: TimeTableView.TOP_HEIGHT+1 + i*Int(hourHeight), width: w, height: Int(hourHeight-1)))
            view.backgroundColor = UIColor.white
            
            let labelStartTime = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: Int(hourHeight*0.3)))
            let labelEndTime = UILabel(frame: CGRect(x: 0, y: Int(hourHeight*0.7), width: w, height:Int(hourHeight*0.3)))
            
            labelStartTime.text = "\((startT + i*3600)/3600)"
            labelStartTime.font = labelStartTime.font.withSize(10)
            labelStartTime.textAlignment = NSTextAlignment.center
            
            view.addSubview(labelStartTime)
            view.addSubview(labelEndTime)
            
            col0.addSubview(view)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

class TimeTableViewCol: UIStackView
{
    public var timeTables:[LectureTimeTable] = []
    var date:Date
    
    required init(coder: NSCoder) {
        date = Date()
        super.init(coder: coder)
    }
    
    public func SetDate(date:Date)
    {
        self.date = date
        timeTables = LectureDataManager.shared.GetSomedayLectures(date: date)
    }
    
    
    public func Go(width:CGFloat, hourHeight:CGFloat, minTime:Int, maxTime:Int)
    {
        
        let hH = Int(hourHeight)
        var t = minTime
        
        for time in timeTables {
            while(time.timeStart > t)
            {
                let t2 = min(time.timeStart, t + 3600)
                
                let h = Int(ceil(hourHeight*CGFloat(t2-t)/3600)) - 1
                
                let v = UIView(frame: CGRect(x: 0, y: 1+TimeTableView.TOP_HEIGHT + Int(hH*(t-minTime)/3600), width: Int(width-1), height: h))
                v.backgroundColor = UIColor.white
                self.addSubview(v)
                t = t2 - t2%1800
            }
            
            let view = TimeTableViewCell()
            view.Init(width: width, hourHeight: hourHeight, time: time, minTime: minTime, date:date)
            self.addSubview(view)
            
            t = time.timeEnd
        }
        while(t < maxTime)
        {
            var t2 = min(maxTime, t + 3600)
            t2 -= t2%3600
            
            let h = Int(ceil(hourHeight*CGFloat(t2-t)/3600)) - 1
            
            let v = UIView(frame: CGRect(x: 0, y: 1+TimeTableView.TOP_HEIGHT + Int(hH*(t-minTime)/3600), width: Int(width-1), height: h))
            v.backgroundColor = UIColor.white
            self.addSubview(v)
            t = t2 - t2%1800
        }
    }
    
    public func AddWeekDayLabel(width:CGFloat)
    {
        let label = UILabel(frame:CGRect(x: 0, y: 1, width: Int(width-1), height: TimeTableView.TOP_HEIGHT-1))
        if EasyCalendar.isToday(date: date){
            label.text = "오늘"
        }
        else {
            label.text = Easy.DateToText(date: date,dateFormat: "M.dd")
        }
        label.font = label.font.withSize(10)
        label.backgroundColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
    }
    
}

class TimeTableViewCell: UIView
{
    var date:Date!
    
    public func Init(width:CGFloat, hourHeight:CGFloat, time:LectureTimeTable, minTime:Int, date:Date)
    {
        
        
        var y = Int(hourHeight * CGFloat(time.timeStart-minTime)/3600) + TimeTableView.TOP_HEIGHT + 1
        var h = Int(ceil(hourHeight * CGFloat(time.timeEnd-time.timeStart)/3600)) - 1
        if(time.timeStart%3600 != 0){
            h-=1
            y+=1
        }
        
        self.backgroundColor = LectureDataManager.shared.GetLecture(id: time.lectureId)?.color
        self.frame = CGRect(x: 0, y: y, width: Int(width-1), height: h)
        self.date = date
        
        AddLabels(time: time)
    }
    
    func AddLabels(time:LectureTimeTable!)
    {
        var f = self.frame
        let nameLabel = UILabel(frame: CGRect(x: f.width * 0.05, y: 2, width: f.width * 0.9, height: CGFloat(floor(f.height*0.5))))
        let lecture = LectureDataManager.shared.GetLecture(id: time.lectureId)
        
        nameLabel.font = nameLabel.font.withSize(9)
        nameLabel.textColor = UIColor.white
        nameLabel.lineBreakMode = .byCharWrapping
        nameLabel.numberOfLines = 0
        nameLabel.text = lecture?.name
        nameLabel.sizeToFit()
        self.addSubview(nameLabel)
        
        f = self.frame
        var f0 = nameLabel.frame
        let label = UILabel(frame:CGRect (x: f.width * 0.05, y: f0.maxY + 2, width: f.width * 0.9, height: floor(f.height*0.5)))
        
        label.font = label.font.withSize(8)
        label.textColor = lecture?.color.mul(n:0.5)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.text = time.room
        label.sizeToFit()
        self.addSubview(label)
        
        for day in time.hyugangDays {
            if EasyCalendar.IsSameDay(date1: day, date2: self.date) {
                self.alpha = 0.5
                label.textColor = UIColor.red
                label.text = "휴강"
                break
            }
        }
        
        if let day = time.bogangDay {
            if EasyCalendar.IsSameDay(date1: day, date2: self.date) {
                
                f0 = label.frame
                let label = UILabel(frame:CGRect (x: f.width * 0.05, y: f0.minY, width: f.width * 0.9, height: f0.height))
                
                label.font = label.font.withSize(8)
                label.textColor = UIColor(red: 0.3, green: 0.3, blue: 1, alpha: 1)
                label.textAlignment = .right
                label.text = "보강"
                self.addSubview(label)
            }
        }
    }
}
