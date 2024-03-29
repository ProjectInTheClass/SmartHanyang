//
//  UtilFuncs.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 19..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit


public class Easy
{
    static var GoodColors:[UIColor] = [
        UIColor(hexString:"#16a085")
        ,UIColor(hexString:"#f39c12")
        ,UIColor(hexString:"#27ae60")
        ,UIColor(hexString:"#d35400")
        ,UIColor(hexString:"#2980b9")
        ,UIColor(hexString:"#c0392b")
        ,UIColor(hexString:"#8e44ad")
        ,UIColor(hexString:"#44596e")
    ]
    
    public static func GetGoodColor(n:Int)->UIColor {
        return GoodColors[n%GoodColors.count]
    }
    
    public static func TimeToText(time:Int, blank:Int = 0) -> String
    {
        var str = ""
        
        let hour:Int = (time/3600);
        let min:Int = (time%3600)/60;
        var a = ":"
        
        var b = blank
        while(b > 0){
            b -= 1
            a = " \(a) "
        }
        
        str += " \(String(format: "%2.2i", hour))\(a)\(String(format: "%2.2i", min))"
        return str
    }
    
    public static func DateToText(date:Date, dateFormat:String = "yyyy.MM.dd") -> String
    {
        var c = EasyCalendar.GetAllComponents(date: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let s = dateFormatter.string(from: date)
        
        let str = "\(s)(\(WeekdayToString(weekDay: c.weekday!)))"
        return str
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
    
    public static func ShowAlert(me:UIViewController, title:String, message:String, f:((Bool)->Void)?=nil)
    {
        let alertController = UIAlertController(title: title,message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //UIAlertActionStye.destructive 지정 글꼴 색상 변경
        let okAction = UIAlertAction(title: "확인", style: .default){ (action: UIAlertAction) in
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
        me.present(alertController,animated: true,completion: nil)
    }
}

public class EasyCalendar
{
    public static func GetDateFromToday(day:Int = 0) -> Date
    {
        var date = Date()
        date.addTimeInterval(TimeInterval(Float(day)*3600*24))
        
        return date
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
        
        let components1 = cal.dateComponents([.day, .hour], from: date1)
        let components2 = cal.dateComponents([.day, .hour], from: date2)
        let d1 = components1.day
        let d2 = components2.day
        return d1 == d2
    }
    
    public static func DDay(from:Date,to:Date) -> Int
    {
        let c = CurrentCalendar()
        let dc = c.dateComponents([.day, .hour], from:from, to: to)
        return dc.day! + ((dc.hour! > 0) ? 1:0)
    }
}


extension URLRequest {
    static func allowsAnyHTTPSCertificateForHost (host : String) -> Bool {
        return true
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
    func rgb() -> (Float, Float, Float) {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
        return (Float(fRed),Float(fGreen),Float(fBlue))
    }
    
    func mul(n:CGFloat) -> UIColor {
        let rgb = self.rgb()
        return UIColor(red: CGFloat(rgb.0) * n, green: CGFloat(rgb.1) * n, blue: CGFloat(rgb.2) * n, alpha: 1)
    }
}
