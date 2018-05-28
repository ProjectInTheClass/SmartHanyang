//
//  DataMager.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 14..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation




class LectureDataManager
{
    static let fileName: String = "data.brch"

    static let documentPath = NSSearchPathForDirectoriesInDomains(
        FileManager.SearchPathDirectory.documentDirectory,
        FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    let filePath = "\(documentPath)/" + fileName
    
    
    static let shared = LectureDataManager();
    public var lectures:[Lecture] = [];
    var lastId:Int = -1
    var listeners:[()->Void] = []
    
    init() {
        
    }
    
    public func addUpdateEventListener(f:@escaping ()->Void)
    {
        listeners.append(f)
    }
    
    func dispatchEvent()
    {
        for f in listeners
        {
            f()
        }
    }
    
    public func GetNewId() -> Int
    {
        if(lastId != -1)
        {
            lastId += 1
            return lastId
        }
        for lecture in lectures
        {
            if lecture.id >= lastId
            {
                lastId = lecture.id + 1
            }
        }
        if(lastId == -1)
        {
            lastId = 0
        }
        return lastId
    }
    
    public func Load()
    {
        lectures.removeAll()
        
        //TODO
        //아래는 임시 테스트용 코드
        
        let softwareStudio1 = Lecture(name: "소프트웨어스튜디오1")
        softwareStudio1.professor = "윤성관"
        softwareStudio1.AddTime(day: 5, room: "IT/BT 509", timeStart: 16, timeEnd: 19)
        softwareStudio1.AddTime(day: 6, room: "IT/BT 509", timeStart: 16, timeEnd: 18)
        softwareStudio1.AddTime(day: 1, room: "IT/BT 509", timeStart: 16, timeEnd: 18)
        
        
        let storytelling = Lecture(name:"디지털스토리텔링의이해")
        storytelling.professor = "김은정"
        storytelling.AddTime(day: 2, room: "인문관 B104", timeStart: 13.5, timeEnd: 15.5)
        storytelling.AddTime(day: 3, room: "인문관 B104", timeStart: 13.5, timeEnd: 15.5)
        
        
        let automata = Lecture(name:"오토마타")
        automata.professor = "박희진"
        automata.AddTime(day:4, room:"IT/BT 508", timeStart: 14.5, timeEnd: 16)
        automata.AddTime(day:6, room:"IT/BT 508", timeStart: 14.5, timeEnd: 16)
        automata.AddTime(day:1, room:"IT/BT 508", timeStart: 14.5, timeEnd: 16)
        
        
        let os = Lecture(name:"운영체제")
        os.professor = "유민수"
        os.AddTime(day: 2, room: "IT/BT 501", timeStart: 16, timeEnd: 18)
        os.AddTime(day: 4, room: "IT/BT 501", timeStart: 16, timeEnd: 18)
        os.AddTime(day: 6, room: "IT/BT 503", timeStart: 10, timeEnd: 12)
        os.AddTime(day: 1, room: "IT/BT 503", timeStart: 10, timeEnd: 12)
        
        
        let soundTec = Lecture(name: "아트테크놀로지사운드")
        soundTec.professor = "정은주"
        soundTec.AddTime(day: 5, room: "제2공학관 PC1", timeStart: 10, timeEnd: 13)
        
        
        let computerStructure = Lecture(name:"컴퓨터구조")
        computerStructure.professor = "박영준"
        computerStructure.AddTime(day: 5, room: "IT/BT 207", timeStart: 13, timeEnd: 14.5)
        computerStructure.AddTime(day: 6, room: "IT/BT 207", timeStart: 13, timeEnd: 14.5)
        computerStructure.AddTime(day: 1, room: "IT/BT 207", timeStart: 13, timeEnd: 14.5)
        
        lectures.append(softwareStudio1);
        lectures.append(storytelling);
        lectures.append(automata);
        lectures.append(os);
        lectures.append(soundTec);
        lectures.append(computerStructure);
 
        /*
        //위에처럼 따로따로 하지 않고 전체를 아카이브를 이용해서 저장하고 로드
        if FileManager.default.fileExists(atPath: filePath) {
            if let unarchArray = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Lecture] {
                lectures = unarchArray
            } else {
                //저장된 파일이 없을때 다시 인터넷에서 파싱해야함
                
            }
        }
 */
        dispatchEvent()
    }
    
    public func Save()
    {
        dispatchEvent()
        
        NSKeyedArchiver.archiveRootObject(lectures, toFile: filePath)
    }
    
    public func GetLecture(id:Int) -> Lecture?
    {
        for lecture in lectures
        {
            if lecture.id == id
            {
                return lecture
            }
        }
        return nil
    }
    
    public func GetLectures() -> [Lecture]
    {
        return lectures
    }
    
    public func GetLecture(name:String) -> Lecture?
    {
        for lecture in lectures
        {
            if lecture.name == name{
                return lecture
            }
        }
        return nil
    }
    
    public func GetTodayLectures() -> [LectureTimeTable]
    {
        var table:[LectureTimeTable] = []
        for lecture in lectures
        {
            table.append(contentsOf:lecture.GetTodayTable())
        }
        table.sort { (l1, l2) -> Bool in
            return l1.timeStart < l2.timeStart
        }
        return table
    }
    
    public func GetSomedayLectures(date:Date) -> [LectureTimeTable]
    {
        var table:[LectureTimeTable] = []
        for lecture in lectures
        {
            table.append(contentsOf:lecture.GetSomedayTable(date:date))
        }
        table.sort { (l1, l2) -> Bool in
            return l1.timeStart < l2.timeStart
        }
        return table
    }
    
    public func AddLecture(lecture:Lecture)
    {
        lectures.append(lecture)
        Save()
    }
}
