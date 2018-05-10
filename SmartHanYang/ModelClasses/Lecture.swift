//
//  Lecture.swift
//  Ultra Rapid Super Power
//
//  Created by gameegg on 2018. 4. 19..
//  Copyright © 2018년 gameegg. All rights reserved.
//

import Foundation

struct LectureTimeTable
{
    var room : String?
    
    //하루 내에서의 시각. second.
    var timeStart : Int?
    //하루 내에서의 시각. second.
    var timeEnd : Int?
    
    //날짜만을 참조. 보강 정보일때만 값이 존재합니다.
    var bogangDay : Date?
    
    public func GetSubtitle() -> String
    {
        return "\(room!)에서 \(TimeToString(time: timeStart!)) - \(TimeToString(time: timeEnd!))"
    }
    
    func TimeToString(time:Int) -> String
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

struct HyugangDay
{
    var day : Int?;
}

class Lecture
{
    public var name : String
    public var professor : String?
    public var timeTables : [Int:LectureTimeTable]?
    public var bogangTimeTables : [LectureTimeTable]?
    
    public var hyugangTables : [HyugangDay]?
    
    init(name:String)
    {
        self.name = name;
        self.timeTables = [Int:LectureTimeTable]()
    }
    
    public func AddTime(day:Int, room:String, timeStart:Double, timeEnd:Double)
    {
        if timeTables!.index(forKey: day) == nil
        {
            timeTables![day] = LectureTimeTable()
        }
        timeTables![day]?.timeStart = Int(timeStart * 60) * 60;
        timeTables![day]?.timeEnd = Int(timeEnd * 60) * 60;
        timeTables![day]?.room = room;
        
    }
    
    public func AddBogang(date:Date, room:String, timeStart:Double, timeEnd:Double)
    {
        var bogangInfo = LectureTimeTable();
        bogangInfo.timeStart = Int(timeStart * 60) * 60;
        bogangInfo.timeEnd = Int(timeEnd * 60) * 60;
        bogangInfo.room = room;
        bogangTimeTables!.append(bogangInfo);
    }
}
