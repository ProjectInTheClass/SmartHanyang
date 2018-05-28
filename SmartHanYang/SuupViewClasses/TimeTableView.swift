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
    
    
    fileprivate static let SIZE_TOP = 30
    
    
    var cols:[TimeTableViewCol] = []
    var weekLectures:[[LectureTimeTable]] = []
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cols.append(col1)
        cols.append(col2)
        cols.append(col3)
        cols.append(col4)
        cols.append(col5)
        
        
        var i = 0;
        var startT = 3600*24
        var endT = 0
        for col in cols {
            col.SetDate(date: EasyCalendar.GetDateFromToday(day: i))
            weekLectures.append(col.timeTable)
            
            for time in col.timeTable {
                startT = min(startT, time.timeStart)
                endT = max(endT, time.timeEnd)
            }
            
            i += 1
        }
        
        InitCol0()
    }
    
    func InitCol0()
    {
        col0.frame = frame
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

class TimeTableViewCol: UIStackView
{
    public var timeTable:[LectureTimeTable] = []
    var date:Date
    
    required init(coder: NSCoder) {
        date = Date()
        super.init(coder: coder)
    }
    
    public func SetDate(date:Date)
    {
        self.date = date
        timeTable = LectureDataManager.shared.GetSomedayLectures(date: date)
        AddWeekDayLabel()
    }
    
    public func SetCellSize()
    {
        
    }
    
    func AddWeekDayLabel()
    {
        let label = UILabel(frame:CGRect(x: 0, y: 0, width: 60, height: TimeTableView.SIZE_TOP))
        label.text = EasyCalendar.WeekdayToString(weekDay: EasyCalendar.GetWeekday(date: date))
        label.font = label.font.withSize(10)
        label.backgroundColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
    }
    
    func AddCells()
    {
        
    }
    
}

class TimeTableViewCell: UIView
{
    public func Init()
    {
        self.backgroundColor = UIColor.gray
        
    }
}
