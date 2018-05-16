//
//  Lecture.swift
//  Ultra Rapid Super Power
//
//  Created by gameegg on 2018. 4. 19..
//  Copyright © 2018년 gameegg. All rights reserved.
//

import Foundation

public struct LectureTimeTable
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
}

class Lecture
{
    public var id : Int
    public var name : String
    public var professor : String
    public var timeTables : [LectureTimeTable]
    public var bogangTimeTables : [LectureTimeTable]
    public var hyugangDays : [Date]
    
    init(name:String)
    {
        self.name = name;
        professor = "알 수 없음"
        self.timeTables = []
        self.id = LectureDataManager.shared.GetNewId()
        bogangTimeTables = []
        hyugangDays = []
    }
    
    public func AddTime(day:Int, room:String, timeStart:Double, timeEnd:Double)
    {
        timeTables.append(LectureTimeTable(
            room: room,
            lectureId: id,
            timeStart: Int(timeStart * 60) * 60,
            timeEnd: Int(timeEnd * 60) * 60,
            weekDay: day,
            bogangDay: nil))
        
    }
    
    public func AddBogang(date:Date, room:String, timeStart:Double, timeEnd:Double)
    {
        let cal = Calendar(identifier: .gregorian)
        let weekDay = cal.component(.weekday, from: date)
        var bogangInfo = LectureTimeTable(
            room: room,
            lectureId: id,
            timeStart: Int(timeStart * 60) * 60,
            timeEnd: Int(timeEnd * 60) * 60,
            weekDay: weekDay,
            bogangDay: date);
        bogangTimeTables.append(bogangInfo)
    }
    
    public func AddHugang(data:Date)
    {
        hyugangDays.append(data)
    }
    
    public func GetTodayTable() -> [LectureTimeTable]
    {
        var ret:[LectureTimeTable] = []
        
        let date = Date()
        var cal = Calendar.current
        cal.timeZone = .current
        
        let weekDay = cal.component(.weekday, from: date) + 1
        let today = cal.dateComponents([.year,.month,.day], from: date)
        
        ret.append(contentsOf:timeTables.filter({$0.weekDay == weekDay}))
        ret.append(contentsOf:bogangTimeTables.filter({ (table) -> Bool in
            if let bogangDay = table.bogangDay
            {
                let tableDay = cal.dateComponents([.year,.month,.day], from: bogangDay)
                let c1 = tableDay.year == today.year
                let c2 = tableDay.month == today.month
                let c3 = tableDay.day == today.day
                
                return c1 && c2 && c3
            }
            else
            {
                return false
            }
        }))
        
        return ret
    }
}
