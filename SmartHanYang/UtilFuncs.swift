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
    
    public static func IsSameDay(date1:Date, date2:Date) -> Bool
    {
        let cal = CurrentCalendar()
        
        let date1_ = cal.startOfDay(for: date1)
        let date2_ = cal.startOfDay(for: date2)
        
        let components = cal.dateComponents([.day], from: date1, to: date2)
        
        return components.day == 0
    }
}
