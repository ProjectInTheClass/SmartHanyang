//
//  GoajeDataManager.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 14..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation


class GoajeDataManager
{
    static let shared = GoajeDataManager();
    var goajes:[Goaje] = []
    var listeners:[()->Void] = []
    
    static let fileName: String = "goajedata.brch"
    static let documentPath = NSSearchPathForDirectoriesInDomains(
        FileManager.SearchPathDirectory.documentDirectory,
        FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    let filePath = "\(documentPath)/" + fileName
    
    public func addUpdateEventListener(f:@escaping ()->Void)
    {
        listeners.append(f)
    }
    
    public func dispatchEvent()
    {
        for f in listeners
        {
            f()
        }
    }
    
    init() {
        
    }
    public func GetNewId() -> Int
    {
        var id = 0
        for goaje in goajes
        {
            if goaje.id >= id
            {
                id = goaje.id + 1
            }
        }
        return id
    }
    
    public func Load()
    {
        goajes.removeAll()
        
        // 아래는 임시 테스트 코드!!!!
        
        /*
        for lecture in LectureDataManager.shared.GetLectures()
        {
            for i in 0...Int(arc4random_uniform(4))
            {
                if i == 0 {
                    continue
                }
            
                let goaje = Goaje()
                goaje.completed = false
                goaje.id = GoajeDataManager.shared.GetNewId()
                goaje.lectureId = lecture.id
                goaje.memo = "메모메모 : " + lecture.name
                goaje.title = "\(lecture.name) 과제 \(i)"
                
                let date = Date()
                goaje.timeEnd = date
                
                goajes.append(goaje)
            }
        }
         */
        /*
        if FileManager.default.fileExists(atPath: filePath) {
            if let unarchArray = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Goaje] {
                goajes = unarchArray
            }
            
        }
        */
        if FileManager.default.fileExists(atPath: filePath) {
            if let data = FileManager.default.contents(atPath: filePath) {
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode([Goaje].self, from: data)
                    goajes = model
                } catch {
                    fatalError(error.localizedDescription)
                }
            } else {
                fatalError("No data at \(filePath)!")
            }
        }
        
        
        dispatchEvent();
    }
    
    public func Save(dispatchE:Bool = true)
    {
        if(dispatchE){
            dispatchEvent();
        }
        
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(goajes)
            if FileManager.default.fileExists(atPath: filePath) {
                try FileManager.default.removeItem(atPath: filePath)
            }
            FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
        }
        catch{
            fatalError(error.localizedDescription)
        }
    }
    
    public func GetGoajes (lecture:Lecture) -> [Goaje]
    {
        return GetGoajes(lectureId: lecture.id)
    }
    
    public func GetGoajes (lectureId:Int) -> [Goaje]
    {
        var ret:[Goaje] = []
        for goaje in goajes
        {
            if goaje.lectureId == lectureId
            {
                ret.append(goaje)
            }
        }
        return ret
    }
    
    public func GetGoajes () -> [Goaje]
    {
        goajes.sort { (a, b) -> Bool in
            if(a.completed == b.completed){
                return a.timeEnd < b.timeEnd
            }
            else{
                return b.completed
            }
        }
        return goajes
    }
    
    public func AddGoaje (goaje:Goaje)
    {
        goajes.append(goaje)
        Save()
    }
    
    public func RemoveGoaje (id:Int)
    {
        goajes = goajes.filter({ (goaje) -> Bool in
            goaje.id != id
        })
        Save(dispatchE: false)
    }
    
    public func EditGoaje (goaje:Goaje)
    {
        goajes = goajes.filter({ (item) -> Bool in
            item.id != goaje.id
        })
        goajes.append(goaje)
        Save(dispatchE: false)
    }
    
    public func DeleteAll()
    {
        goajes = []
        Save()
    }
}
