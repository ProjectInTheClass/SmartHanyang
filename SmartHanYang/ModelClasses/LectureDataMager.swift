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
    var listeners:[String:()->Void] = [:]
    
    init() {
        
    }
    
    public func addUpdateEventListener(key:String,f:@escaping ()->Void)
    {
        listeners[key] = f
    }
    
    public func removeEventListener(key:String)
    {
        listeners.removeValue(forKey: key)
    }
    
    public func dispatchEvent()
    {
        for f in listeners
        {
            f.1()
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
        
        //위에처럼 따로따로 하지 않고 전체를 아카이브를 이용해서 저장하고 로드
        if FileManager.default.fileExists(atPath: filePath) {
            if let unarchArray = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Lecture] {
                lectures = unarchArray
            } else {
                //저장된 파일이 없을때 다시 인터넷에서 파싱해야함
            }
        }
        
        self.dispatchEvent()
    }
    
    public func Save(dispatch:Bool = true)
    {
        if dispatch {
            self.dispatchEvent()
        }
        
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
        lectures = lectures.filter({ (l) -> Bool in
            l.id != lecture.id
        })
        lectures.append(lecture)
        Save()
    }
    
    public func RemoveLecture(id:Int, withSave:Bool = true)
    {
        lectures = lectures.filter({ (lecture) -> Bool in
            lecture.id != id
        })
        if withSave{
            Save()
            
        }
    }
    
    public func DeleteAll()
    {
        lectures = []
        Save()
    }
}
