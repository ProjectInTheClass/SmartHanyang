//
//  UtilFuncs.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 19..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation


public class EasyCalendar
{
    public static func GetDateFromToday(day:Int = 0) -> Date
    {
        var date = Date()
        date.addTimeInterval(TimeInterval(Float(day)*3600*24))
        
        return date
    }
    
    public static func WeekdayToString(weekDay:Int) -> String
    {
        switch weekDay {
        case 1:
            return "일"
        case 2:
            return "월"
        case 3:
            return "화"
        case 4:
            return "수"
        case 5:
            return "목"
        case 6:
            return "금"
        case 7:
            return "토"
        default:
            return "?"
        }
    }
    
    public static func GetDayTimeSecond(date:Date) -> Int
    {
        var t = CurrentCalendar().dateComponents([.hour,.minute,.second], from: date)
        var ret:Int = 0
        
        if let h = t.hour, let m = t.minute, let s = t.second
        {
            ret = h*3600 + m*60 + s
        }
        return ret
    }
    
    public static func GetAllComponents(date:Date) -> DateComponents
    {
        return CurrentCalendar().dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second], from: date)
    }
    
    public static func GetWeekday(date:Date) -> Int
    {
        return CurrentCalendar().component(.weekday, from: date)
    }
    
    public static func CurrentCalendar() -> Calendar
    {
        var c = Calendar.current
        c.timeZone = .current
        return c
    }
    
    public static func isToday(date:Date) -> Bool
    {
        let today = GetAllComponents(date: Date())
        let day = GetAllComponents(date: date)
        
        let c1 = day.year == today.year
        let c2 = day.month == today.month
        let c3 = day.day == today.day
        
        return c1 && c2 && c3
    }
    
    public static func IsSameDay(date1:Date, date2:Date) -> Bool
    {
        let cal = CurrentCalendar()
        
        let date1_ = cal.startOfDay(for: date1)
        let date2_ = cal.startOfDay(for: date2)
        
        let components = cal.dateComponents([.day], from: date1, to: date2)
        
        return components.day == 0
    }
}
