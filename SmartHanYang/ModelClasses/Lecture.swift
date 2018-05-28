//
//  Lecture.swift
//  Ultra Rapid Super Power
//
//  Created by gameegg on 2018. 4. 19..
//  Copyright © 2018년 gameegg. All rights reserved.
//

import Foundation


struct PropertyKey {
    static let room = "room"
    static let lectureId = "lectureId"
    static let timeStart = "timeStart"
    static let timeEnd = "timeEnd"
    static let weekDay = "weekDay"
    static let bogangDay = "bogangDay"
    static let hyugangDays = "hyugangDays"
    static let id = "id"
    static let name = "name"
    static let professor = "professor"
    static let timeTables = "timeTables"
    static let bogangTimeTables = "bogangTimeTables"
}

public class LectureTimeTable: NSObject, NSCoding
{

    var room : String
    var lectureId : Int
    //하루 내에서의 시각. second.
    var timeStart : Int
    //하루 내에서의 시각. second.
    var timeEnd : Int
    //요일
    var weekDay : Int?
    //날짜만을 참조. 보강 정보일때만 값이 존재합니다.
    var bogangDay : Date?
    
    var hyugangDays : [Date] = []
    
    public func GetSubtitle() -> String
    {
        return "\(room)에서 \(GetTimeText())"
    }
    
    public func GetTimeText() -> String
    {
        return "\(TimeToText(time: timeStart)) - \(TimeToText(time: timeEnd))"
    }
    
    public func GetTimeText2() -> String
    {
        return "\(TimeToText2(time: timeStart)) - \(TimeToText2(time: timeEnd))"
    }
    
    private func TimeToText(time:Int) -> String
    {
        var str = ""
        
        let hour:Int = (time/3600);
        let min:Int = (time%3600)/60;
        
        str += " \(String(format: "%2.2i", hour)):\(String(format: "%2.2i", min))"
        return str
    }
    
    private func TimeToText2(time:Int) -> String
    {
        var str = ""
        var tttt:Int = time;
        
        if(time >= 3600 * 12){
            str = "오후"
            tttt -= 3600*12
        }
        else{
            str = "오전"
        }
        let hour:Int = (tttt/3600);
        let min:Int = (tttt%3600)/60;
        
        str += " \(String(format: "%2.2i", hour)):\(String(format: "%2.2i", min))"
        return str
    }
    
    public init(room:String,
              lectureId: Int,
              timeStart: Int,
        timeEnd: Int,
        weekDay: Int,
        bogangDay: Date?, hyugangDays: [Date])
    {
        self.room = room
        self.lectureId = lectureId
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.weekDay = weekDay
        self.bogangDay = bogangDay
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.room, forKey: PropertyKey.room)
        aCoder.encode(self.lectureId, forKey: PropertyKey.lectureId)
        aCoder.encode(self.timeStart, forKey: PropertyKey.timeStart)
        aCoder.encode(self.timeEnd, forKey: PropertyKey.timeEnd)
        aCoder.encode(self.weekDay, forKey: PropertyKey.weekDay)
        aCoder.encode(self.bogangDay, forKey: PropertyKey.bogangDay)
        aCoder.encode(self.hyugangDays, forKey: PropertyKey.hyugangDays)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let room = aDecoder.decodeObject(forKey: PropertyKey.room) as! String
        let lectureId = aDecoder.decodeInteger(forKey: PropertyKey.lectureId) as! Int
        let timeStart = aDecoder.decodeInteger(forKey: PropertyKey.timeStart) as! Int
        let timeEnd = aDecoder.decodeInteger(forKey: PropertyKey.timeEnd) as! Int
        let weekDay = aDecoder.decodeObject(forKey: PropertyKey.weekDay) as! Int //불완전 임시코드
        let bogangDay = aDecoder.decodeObject(forKey: PropertyKey.bogangDay) as? Date
        let hyugangDays = aDecoder.decodeObject(forKey: PropertyKey.hyugangDays) as! [Date]
        
        self.init(room:room, lectureId: lectureId, timeStart: timeStart, timeEnd: timeEnd, weekDay: weekDay, bogangDay: bogangDay, hyugangDays: hyugangDays)

    }


}

class Lecture: NSObject, NSCoding
{
    
    

    
    public var id : Int
    public var name : String
    public var professor : String
    public var timeTables : [LectureTimeTable]
    public var bogangTimeTables : [LectureTimeTable]
    
    init(name:String)
    {
        self.name = name;
        professor = "알 수 없음"
        self.timeTables = []
        self.id = LectureDataManager.shared.GetNewId()
        bogangTimeTables = []
    }
    
    public func AddTime(day:Int, room:String, timeStart:Double, timeEnd:Double)
    {
        timeTables.append(LectureTimeTable(
            room: room,
            lectureId: id,
            timeStart: Int(timeStart * 60) * 60,
            timeEnd: Int(timeEnd * 60) * 60,
            weekDay: day,
            bogangDay: nil, hyugangDays: []))
        
    }
    
    public func AddBogang(date:Date, room:String, timeStart:Double, timeEnd:Double)
    {
        let cal = Calendar(identifier: .gregorian)
        let weekDay = cal.component(.weekday, from: date)
        let bogangInfo = LectureTimeTable(
            room: room,
            lectureId: id,
            timeStart: Int(timeStart * 60) * 60,
            timeEnd: Int(timeEnd * 60) * 60,
            weekDay: weekDay,
            bogangDay: date, hyugangDays: []);
        bogangTimeTables.append(bogangInfo)
    }
    
    public func AddHyugang(date:Date, timeTable:LectureTimeTable)
    {
        timeTable.hyugangDays.append(date)
    }
    
    public func GetTodayTable() -> [LectureTimeTable]
    {
        var ret:[LectureTimeTable] = []
        
        let date = Date()
        var cal = Calendar.current
        cal.timeZone = .current
        
        let weekDay = cal.component(.weekday, from: date)
        
        ret.append(contentsOf:timeTables.filter({$0.weekDay == weekDay}))
        ret.append(contentsOf:bogangTimeTables.filter({ (table) -> Bool in
            if let bogangDay = table.bogangDay
            {
                return EasyCalendar.isToday(date: bogangDay)
            }
            else
            {
                return false
            }
        }))
        
        return ret
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: PropertyKey.id)
        aCoder.encode(self.name, forKey: PropertyKey.name)
        aCoder.encode(self.professor, forKey: PropertyKey.professor)
        aCoder.encode(self.timeTables, forKey: PropertyKey.timeTables)
        aCoder.encode(self.bogangTimeTables, forKey: PropertyKey.bogangTimeTables)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: PropertyKey.id) as! Int
        self.name = aDecoder.decodeObject(forKey: PropertyKey.name) as! String
        self.professor = aDecoder.decodeObject(forKey:PropertyKey.professor) as! String
        self.timeTables = aDecoder.decodeObject(forKey:PropertyKey.timeTables) as! [LectureTimeTable]
        self.bogangTimeTables = aDecoder.decodeObject(forKey: PropertyKey.bogangTimeTables) as! [LectureTimeTable]
    }
}
