//
//  ParseJson.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 11..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation




func ParseJson(json:String, yoil:Int)
{
    print("json 보여줘")
    print(json)
    
    enum Tags: String {
        case classroom = "\"GANGUISIL_NM\":\""
        case startTime = "\"START_TM\":\""
        case endTime = "\"END_TM\":\""
        case subject = "\"GWAMOK_NM\":\""
        case prof = "\"NAME\":\""
        
        static let cases = [classroom, startTime, endTime, subject, prof]
    }
    
    
    
    var str:String = json.components(separatedBy:["[", "]"])[1]
    str = str.replacingOccurrences(of: ",", with: "")
    str = str.replacingOccurrences(of: "\n", with: "")
    var subs: [String] = str.components(separatedBy: ["{", "}"])
    
    
    var i:Int = 0
    
    
    typealias LectureInfo = (lectureName: String, profName: String, classroom: String, startTime: Double, endTime: Double)
    
    var lectureInfos: [LectureInfo] = Array<LectureInfo>()
    
    
    for sub in subs {
        var lec:LectureInfo = ("", "" ,"", 0.0, 0.0)
        if(sub.isEmpty) {
            continue
        }
        
        for tag in Tags.cases {
            var substring:String = sub.components(separatedBy: tag.rawValue)[1]
            substring = substring.components(separatedBy: "\"")[0]
           
            switch(tag) {
                
            case Tags.classroom:
                var substrings: [String] = substring.components(separatedBy: [" "])
                substrings.removeFirst()
                substring = "";
                for str in substrings {
                    substring = "\(substring) \(str)"
                }
                substring.removeFirst()
                substring = substring.replacingOccurrences(of: "강의실", with: "")
                substring = substring.replacingOccurrences(of: "IT.BT관", with: "IT/BT")
                substring = substring.replacingOccurrences(of: "정석현 ", with: "")
                lec.classroom = substring
            case .startTime:
                var timestr:String = substring.replacingOccurrences(of: ":", with:".")
                timestr = timestr.replacingOccurrences(of: ".3", with: ".5")
                let time:Double = Double(timestr)!
                lec.startTime = time
            case .endTime:
                var timestr:String = substring.replacingOccurrences(of: ":", with:".")
                timestr = timestr.replacingOccurrences(of: ".3", with: ".5")
                let time:Double = Double(timestr)!
                lec.endTime = time
            case .subject:
                lec.lectureName = substring
            case .prof:
                lec.profName = substring
            default:
                print("Error: Tag ")
                
                
            }
            
        }
        lectureInfos.append(lec)
        
        i += 1
    }
    
    i = 0
    print(lectureInfos.count)
    var arrangedLectureInfos: [LectureInfo] = Array<LectureInfo>()
    var lec: LectureInfo = ("", "", "", 0.0, 0.0)
    while (i < lectureInfos.count) {
        if(lec.lectureName.isEmpty) {
            lec.lectureName = lectureInfos[i].lectureName
            lec.profName = lectureInfos[i].profName
            lec.classroom = lectureInfos[i].classroom
            lec.startTime = lectureInfos[i].startTime
        }
        
        if(lec.lectureName == lectureInfos[i].lectureName &&
            lec.classroom == lectureInfos[i].classroom) {
            lec.endTime = lectureInfos[i].endTime
        } else {
            arrangedLectureInfos.append(lec)
            lec = ("", "", "", 0.0, 0.0)
            continue
        }
        if(i == lectureInfos.count - 1){
            arrangedLectureInfos.append(lec)
        }
        i += 1
    }
    
    var lectures:[Lecture] = LectureDataManager.shared.GetLectures()
    
    for lecInfo in arrangedLectureInfos {
        var _lecture:Lecture? = nil
        var isNewLecture = false
        for l in lectures
        {
            if l.name == lecInfo.lectureName
            {
                _lecture = l
                break
            }
        }
        if _lecture == nil
        {
            isNewLecture = true
            _lecture = Lecture(name: lecInfo.lectureName)
            lectures.append(_lecture!)
            LectureDataManager.shared.AddLecture(lecture: _lecture!)
        }
        if let lecture = _lecture
        {
            lecture.professor = lecInfo.profName
            
            print("addTime : yoil:\(yoil), lectureName:\(lecture.name)")
            lecture.AddTime(day: yoil, room: lecInfo.classroom, timeStart: lecInfo.startTime, timeEnd: lecInfo.endTime)
        }
    }
    LectureDataManager.shared.Save()
    
}


let json1 = "{'result':{'totalCount':14,'list':[{'HAKSU_NO':'ELE3021','SEQ':'1','GYGJ_CD':'HH20162019','HAKBUN':'2012003460','GEONMUL_NM':'IT.BT관','GNJ_SOSOK_CD':'H0002519','BUNBAN_NO':'01','HAKJEOM':3,'GANGUISIL_NM':'H305-0503 IT.BT관 503강의실','SUUP_TERM':'10','GYOSI':'5','NAME':'유민수','START_TM':'10:00','END_TM':'10:30','SUUP_NO':'12782','GWAMOK_NM':'운영체제','SUUP_YEAR':'2018'},{'NAME':'유민수','GNJ_SOSOK_CD':'H0002519','GYGJ_CD':'HH20162019','HAKSU_NO':'ELE3021','GWAMOK_NM':'운영체제','SEQ':'1','HAKJEOM':3,'GYOSI':'6','GANGUISIL_NM':'H305-0503 IT.BT관 503강의실','SUUP_NO':'12782','SUUP_TERM':'10','END_TM':'11:00','SUUP_YEAR':'2018','HAKBUN':'2012003460','BUNBAN_NO':'01','START_TM':'10:30','GEONMUL_NM':'IT.BT관'},{'GYOSI':'7','GANGUISIL_NM':'H305-0503 IT.BT관 503강의실','SUUP_TERM':'10','SEQ':'1','GYGJ_CD':'HH20162019','START_TM':'11:00','SUUP_YEAR':'2018','HAKBUN':'2012003460','NAME':'유민수','SUUP_NO':'12782','HAKSU_NO':'ELE3021','GNJ_SOSOK_CD':'H0002519','GWAMOK_NM':'운영체제','BUNBAN_NO':'01','HAKJEOM':3,'GEONMUL_NM':'IT.BT관','END_TM':'11:30'},{'GWAMOK_NM':'운영체제','SUUP_TERM':'10','GNJ_SOSOK_CD':'H0002519','END_TM':'12:00','GYGJ_CD':'HH20162019','HAKSU_NO':'ELE3021','SUUP_YEAR':'2018','SEQ':'1','BUNBAN_NO':'01','GYOSI':'8','SUUP_NO':'12782','HAKBUN':'2012003460','GEONMUL_NM':'IT.BT관','START_TM':'11:30','NAME':'유민수','HAKJEOM':3,'GANGUISIL_NM':'H305-0503 IT.BT관 503강의실'},{'SUUP_YEAR':'2018','END_TM':'13:30','GANGUISIL_NM':'H305-0207 IT.BT관 207강의실','SUUP_TERM':'10','HAKSU_NO':'ITE2031','GNJ_SOSOK_CD':'H0002519','BUNBAN_NO':'01','GYOSI':'11','SUUP_NO':'10879','GWAMOK_NM':'컴퓨터구조론','SEQ':'1','START_TM':'13:00','NAME':'박영준','HAKBUN':'2012003460','GEONMUL_NM':'IT.BT관','HAKJEOM':3,'GYGJ_CD':'HH20162019'},{'END_TM':'14:00','NAME':'박영준','GYOSI':'12','SUUP_NO':'10879','GWAMOK_NM':'컴퓨터구조론','SUUP_YEAR':'2018','GYGJ_CD':'HH20162019','HAKJEOM':3,'GANGUISIL_NM':'H305-0207 IT.BT관 207강의실','SUUP_TERM':'10','BUNBAN_NO':'01','START_TM':'13:30','HAKBUN':'2012003460','GEONMUL_NM':'IT.BT관','SEQ':'1','HAKSU_NO':'ITE2031','GNJ_SOSOK_CD':'H0002519'},{'SUUP_NO':'10879','GANGUISIL_NM':'H305-0207 IT.BT관 207강의실','NAME':'박영준','SUUP_TERM':'10','GYOSI':'13','SUUP_YEAR':'2018','HAKJEOM':3,'GNJ_SOSOK_CD':'H0002519','GEONMUL_NM':'IT.BT관','HAKSU_NO':'ITE2031','GYGJ_CD':'HH20162019','HAKBUN':'2012003460','BUNBAN_NO':'01','START_TM':'14:00','END_TM':'14:30','GWAMOK_NM':'컴퓨터구조론','SEQ':'1'},{'GNJ_SOSOK_CD':'H0002519','START_TM':'14:30','HAKBUN':'2012003460','NAME':'박희진','SEQ':'1','HAKJEOM':3,'BUNBAN_NO':'01','GEONMUL_NM':'IT.BT관','SUUP_TERM':'10','SUUP_YEAR':'2018','GYOSI':'14','GYGJ_CD':'HH20162019','GWAMOK_NM':'오토마타및계산이론','GANGUISIL_NM':'H305-0508 IT.BT관 508강의실','SUUP_NO':'10880','END_TM':'15:00','HAKSU_NO':'ITE3061'},{'BUNBAN_NO':'01','GYOSI':'15','SUUP_TERM':'10','GYGJ_CD':'HH20162019','SEQ':'1','GANGUISIL_NM':'H305-0508 IT.BT관 508강의실','SUUP_YEAR':'2018','SUUP_NO':'10880','HAKBUN':'2012003460','NAME':'박희진','START_TM':'15:00','END_TM':'15:30','GEONMUL_NM':'IT.BT관','GNJ_SOSOK_CD':'H0002519','HAKSU_NO':'ITE3061','HAKJEOM':3,'GWAMOK_NM':'오토마타및계산이론'},{'NAME':'박희진','GANGUISIL_NM':'H305-0508 IT.BT관 508강의실','GWAMOK_NM':'오토마타및계산이론','START_TM':'15:30','HAKSU_NO':'ITE3061','HAKBUN':'2012003460','GEONMUL_NM':'IT.BT관','END_TM':'16:00','GYGJ_CD':'HH20162019','HAKJEOM':3,'SUUP_TERM':'10','GYOSI':'16','GNJ_SOSOK_CD':'H0002519','SUUP_YEAR':'2018','BUNBAN_NO':'01','SEQ':'1','SUUP_NO':'10880'},{'SUUP_TERM':'10','NAME':'윤성관','HAKSU_NO':'ITE3063','GYOSI':'17','SUUP_YEAR':'2018','START_TM':'16:00','END_TM':'16:30','GYGJ_CD':'HH20162019','GWAMOK_NM':'소프트웨어스튜디오1','SEQ':'1','GANGUISIL_NM':'H305-0509 IT.BT관 509강의실','HAKJEOM':3,'SUUP_NO':'10882','HAKBUN':'2012003460','BUNBAN_NO':'01','GEONMUL_NM':'IT.BT관','GNJ_SOSOK_CD':'H0002519'},{'HAKBUN':'2012003460','GANGUISIL_NM':'H305-0509 IT.BT관 509강의실','GYOSI':'18','GWAMOK_NM':'소프트웨어스튜디오1','SUUP_TERM':'10','GYGJ_CD':'HH20162019','END_TM':'17:00','SEQ':'1','BUNBAN_NO':'01','SUUP_NO':'10882','HAKJEOM':3,'NAME':'윤성관','GEONMUL_NM':'IT.BT관','SUUP_YEAR':'2018','GNJ_SOSOK_CD':'H0002519','START_TM':'16:30','HAKSU_NO':'ITE3063'},{'HAKJEOM':3,'SUUP_NO':'10882','NAME':'윤성관','GWAMOK_NM':'소프트웨어스튜디오1','GYGJ_CD':'HH20162019','GYOSI':'19','GEONMUL_NM':'IT.BT관','SUUP_YEAR':'2018','GANGUISIL_NM':'H305-0509 IT.BT관 509강의실','SUUP_TERM':'10','HAKBUN':'2012003460','HAKSU_NO':'ITE3063','BUNBAN_NO':'01','END_TM':'17:30','SEQ':'1','START_TM':'17:00','GNJ_SOSOK_CD':'H0002519'},{'NAME':'윤성관','START_TM':'17:30','SUUP_NO':'10882','GEONMUL_NM':'IT.BT관','HAKJEOM':3,'BUNBAN_NO':'01','GYGJ_CD':'HH20162019','SEQ':'1','GWAMOK_NM':'소프트웨어스튜디오1','HAKBUN':'2012003460','END_TM':'18:00','SUUP_YEAR':'2018','GNJ_SOSOK_CD':'H0002519','GANGUISIL_NM':'H305-0509 IT.BT관 509강의실','GYOSI':'20','HAKSU_NO':'ITE3063','SUUP_TERM':'10'}]},'nowDate':{'dd':'11','mm':'05','yoil':'6','yyyy':'2018'},'resultMessage':{'service':'/HASA/A201300018','code':200,'msg':'}}"

let json2 = "{'result':{'totalCount':15,'list':[{'SUUP_NO':'15002','HAKSU_NO':'ATC0007','HAKJEOM':3,'END_TM':'10:30','BUNBAN_NO':'01','GYGJ_CD':'HH20162019','HAKBUN':'2012003460','GNJ_SOSOK_CD':'H0003958','SUUP_YEAR':'2018','SUUP_TERM':'10','GYOSI':'5','START_TM':'10:00','SEQ':'1','NAME':'정은주','GANGUISIL_NM':'H211-PC1 제2공학관 정석현 PC 1','GEONMUL_NM':'제2공학관','GWAMOK_NM':'아트테크놀로지사운드컴퓨팅'},{'END_TM':'11:00','HAKSU_NO':'ATC0007','GEONMUL_NM':'제2공학관','SUUP_TERM':'10','SUUP_NO':'15002','NAME':'정은주','GNJ_SOSOK_CD':'H0003958','GYOSI':'6','START_TM':'10:30','SEQ':'1','HAKBUN':'2012003460','GWAMOK_NM':'아트테크놀로지사운드컴퓨팅','BUNBAN_NO':'01','GYGJ_CD':'HH20162019','SUUP_YEAR':'2018','GANGUISIL_NM':'H211-PC1 제2공학관 정석현 PC 1','HAKJEOM':3},{'START_TM':'11:00','GWAMOK_NM':'아트테크놀로지사운드컴퓨팅','BUNBAN_NO':'01','HAKSU_NO':'ATC0007','END_TM':'11:30','SUUP_YEAR':'2018','SUUP_TERM':'10','HAKJEOM':3,'SUUP_NO':'15002','GNJ_SOSOK_CD':'H0003958','HAKBUN':'2012003460','GEONMUL_NM':'제2공학관','SEQ':'1','GANGUISIL_NM':'H211-PC1 제2공학관 정석현 PC 1','GYGJ_CD':'HH20162019','NAME':'정은주','GYOSI':'7'},{'HAKJEOM':3,'HAKBUN':'2012003460','START_TM':'11:30','GWAMOK_NM':'아트테크놀로지사운드컴퓨팅','HAKSU_NO':'ATC0007','END_TM':'12:00','NAME':'정은주','SEQ':'1','BUNBAN_NO':'01','GANGUISIL_NM':'H211-PC1 제2공학관 정석현 PC 1','GYGJ_CD':'HH20162019','SUUP_YEAR':'2018','SUUP_TERM':'10','GYOSI':'8','GNJ_SOSOK_CD':'H0003958','GEONMUL_NM':'제2공학관','SUUP_NO':'15002'},{'SUUP_YEAR':'2018','GWAMOK_NM':'아트테크놀로지사운드컴퓨팅','HAKBUN':'2012003460','END_TM':'12:30','HAKSU_NO':'ATC0007','GANGUISIL_NM':'H211-PC1 제2공학관 정석현 PC 1','GYGJ_CD':'HH20162019','SUUP_TERM':'10','START_TM':'12:00','SEQ':'1','SUUP_NO':'15002','BUNBAN_NO':'01','GEONMUL_NM':'제2공학관','HAKJEOM':3,'GNJ_SOSOK_CD':'H0003958','NAME':'정은주','GYOSI':'9'},{'GYGJ_CD':'HH20162019','START_TM':'12:30','SUUP_YEAR':'2018','SUUP_NO':'15002','SUUP_TERM':'10','END_TM':'13:00','GWAMOK_NM':'아트테크놀로지사운드컴퓨팅','NAME':'정은주','HAKBUN':'2012003460','HAKJEOM':3,'GYOSI':'10','GEONMUL_NM':'제2공학관','GANGUISIL_NM':'H211-PC1 제2공학관 정석현 PC 1','HAKSU_NO':'ATC0007','SEQ':'1','BUNBAN_NO':'01','GNJ_SOSOK_CD':'H0003958'},{'GEONMUL_NM':'IT.BT관','BUNBAN_NO':'01','NAME':'박영준','SUUP_TERM':'10','HAKBUN':'2012003460','HAKSU_NO':'ITE2031','SUUP_NO':'10879','SEQ':'1','SUUP_YEAR':'2018','GYOSI':'11','START_TM':'13:00','GYGJ_CD':'HH20162019','HAKJEOM':3,'GANGUISIL_NM':'H305-0207 IT.BT관 207강의실','GWAMOK_NM':'컴퓨터구조론','GNJ_SOSOK_CD':'H0002519','END_TM':'13:30'},{'NAME':'박영준','HAKJEOM':3,'GYOSI':'12','BUNBAN_NO':'01','GANGUISIL_NM':'H305-0207 IT.BT관 207강의실','HAKSU_NO':'ITE2031','SUUP_TERM':'10','GWAMOK_NM':'컴퓨터구조론','GYGJ_CD':'HH20162019','END_TM':'14:00','SUUP_YEAR':'2018','GNJ_SOSOK_CD':'H0002519','SUUP_NO':'10879','HAKBUN':'2012003460','SEQ':'1','GEONMUL_NM':'IT.BT관','START_TM':'13:30'},{'GNJ_SOSOK_CD':'H0002519','START_TM':'14:00','GWAMOK_NM':'컴퓨터구조론','SUUP_NO':'10879','NAME':'박영준','BUNBAN_NO':'01','HAKBUN':'2012003460','GYOSI':'13','SEQ':'1','SUUP_TERM':'10','SUUP_YEAR':'2018','HAKSU_NO':'ITE2031','HAKJEOM':3,'GEONMUL_NM':'IT.BT관','GANGUISIL_NM':'H305-0207 IT.BT관 207강의실','GYGJ_CD':'HH20162019','END_TM':'14:30'},{'SUUP_TERM':'10','GWAMOK_NM':'소프트웨어스튜디오1','HAKSU_NO':'ITE3063','BUNBAN_NO':'01','NAME':'윤성관','GEONMUL_NM':'IT.BT관','HAKBUN':'2012003460','GANGUISIL_NM':'H305-0509 IT.BT관 509강의실','SUUP_NO':'10882','GYOSI':'17','SEQ':'1','SUUP_YEAR':'2018','START_TM':'16:00','HAKJEOM':3,'GNJ_SOSOK_CD':'H0002519','END_TM':'16:30','GYGJ_CD':'HH20162019'},{'BUNBAN_NO':'01','GANGUISIL_NM':'H305-0509 IT.BT관 509강의실','GYOSI':'18','GNJ_SOSOK_CD':'H0002519','GWAMOK_NM':'소프트웨어스튜디오1','START_TM':'16:30','SUUP_NO':'10882','GEONMUL_NM':'IT.BT관','SEQ':'1','SUUP_TERM':'10','HAKBUN':'2012003460','END_TM':'17:00','HAKSU_NO':'ITE3063','GYGJ_CD':'HH20162019','HAKJEOM':3,'NAME':'윤성관','SUUP_YEAR':'2018'},{'SUUP_TERM':'10','HAKJEOM':3,'END_TM':'17:30','GNJ_SOSOK_CD':'H0002519','SUUP_NO':'10882','SEQ':'1','START_TM':'17:00','GANGUISIL_NM':'H305-0509 IT.BT관 509강의실','SUUP_YEAR':'2018','GYGJ_CD':'HH20162019','GEONMUL_NM':'IT.BT관','GWAMOK_NM':'소프트웨어스튜디오1','NAME':'윤성관','GYOSI':'19','HAKBUN':'2012003460','BUNBAN_NO':'01','HAKSU_NO':'ITE3063'},{'SEQ':'1','HAKSU_NO':'ITE3063','HAKJEOM':3,'GEONMUL_NM':'IT.BT관','SUUP_NO':'10882','GWAMOK_NM':'소프트웨어스튜디오1','START_TM':'17:30','GANGUISIL_NM':'H305-0509 IT.BT관 509강의실','SUUP_TERM':'10','GYGJ_CD':'HH20162019','GNJ_SOSOK_CD':'H0002519','HAKBUN':'2012003460','END_TM':'18:00','BUNBAN_NO':'01','NAME':'윤성관','SUUP_YEAR':'2018','GYOSI':'20'},{'GEONMUL_NM':'IT.BT관','START_TM':'18:00','BUNBAN_NO':'01','SUUP_YEAR':'2018','HAKJEOM':3,'GNJ_SOSOK_CD':'H0002519','NAME':'윤성관','SUUP_NO':'10882','SUUP_TERM':'10','END_TM':'18:30','GYOSI':'21','SEQ':'1','GWAMOK_NM':'소프트웨어스튜디오1','HAKBUN':'2012003460','GYGJ_CD':'HH20162019','HAKSU_NO':'ITE3063','GANGUISIL_NM':'H305-0509 IT.BT관 509강의실'},{'BUNBAN_NO':'01','HAKSU_NO':'ITE3063','HAKBUN':'2012003460','START_TM':'18:30','SUUP_TERM':'10','GEONMUL_NM':'IT.BT관','GNJ_SOSOK_CD':'H0002519','END_TM':'19:00','NAME':'윤성관','HAKJEOM':3,'SEQ':'1','GANGUISIL_NM':'H305-0509 IT.BT관 509강의실','GWAMOK_NM':'소프트웨어스튜디오1','GYOSI':'22','SUUP_YEAR':'2018','GYGJ_CD':'HH20162019','SUUP_NO':'10882'}]},'nowDate':{'dd':'11','mm':'05','yoil':'6','yyyy':'2018'},'resultMessage':{'service':'/HASA/A201300018','code':200,'msg':'}}"

