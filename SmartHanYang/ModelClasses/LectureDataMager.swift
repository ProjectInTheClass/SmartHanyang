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
    static let shared = LectureDataManager();
    public var lectures:[Lecture] = [];
    
    init() {
        
    }
    
    public func GetNewId() -> Int
    {
        var id = 0
        for lecture in lectures
        {
            if lecture.id >= id
            {
                id = lecture.id + 1
            }
        }
        return id
    }
    
    public func Load()
    {
        lectures.removeAll()
        
        let softwareStudio1 = Lecture(name: "소프트웨어스튜디오1")
        softwareStudio1.professor = "윤성관"
        softwareStudio1.AddTime(day: 4, room: "IT/BT 509", timeStart: 16, timeEnd: 19)
        softwareStudio1.AddTime(day: 5, room: "IT/BT 509", timeStart: 16, timeEnd: 18)
        
        
        let storytelling = Lecture(name:"디지털스토리텔링의이해")
        storytelling.professor = "김은정"
        storytelling.AddTime(day: 2, room: "인문관 B104", timeStart: 13.5, timeEnd: 15.5)
        
        
        let automata = Lecture(name:"오토마타")
        automata.professor = "박희진"
        automata.AddTime(day:3, room:"IT/BT 508", timeStart: 14.5, timeEnd: 16)
        automata.AddTime(day:5, room:"IT/BT 508", timeStart: 14.5, timeEnd: 16)
        
        
        let os = Lecture(name:"운영체제")
        os.professor = "유민수"
        os.AddTime(day: 3, room: "IT/BT 501", timeStart: 16, timeEnd: 18)
        os.AddTime(day: 5, room: "IT/BT 503", timeStart: 10, timeEnd: 12)
        
        
        let soundTec = Lecture(name: "아트테크놀로지사운드")
        soundTec.professor = "정은주"
        soundTec.AddTime(day: 4, room: "제2공학관 PC1", timeStart: 10, timeEnd: 13)
        
        
        let computerStructure = Lecture(name:"컴퓨터구조")
        computerStructure.professor = "박영준"
        computerStructure.AddTime(day: 4, room: "IT/BT 207", timeStart: 13, timeEnd: 14.5)
        computerStructure.AddTime(day: 5, room: "IT/BT 207", timeStart: 13, timeEnd: 14.5)
        
        lectures.append(softwareStudio1);
        lectures.append(storytelling);
        lectures.append(automata);
        lectures.append(os);
        lectures.append(soundTec);
        lectures.append(computerStructure);
    }
    
    public func Save()
    {
        
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
    
}
