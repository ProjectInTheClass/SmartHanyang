//
//  GoajaeDataManager.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 14..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation


class GoajaeDataManager
{
    static let shared = GoajaeDataManager();
    var goajaes:[Goajae] = []
    
    init() {
        
    }
    public func GetNewId() -> Int
    {
        var id = 0
        for goajae in goajaes
        {
            if goajae.id >= id
            {
                id = goajae.id + 1
            }
        }
        return id
    }
    
    public func Load()
    {
        goajaes.removeAll()
        
        //TODO
        // 아래는 임시 테스트 코드!!!!
        for lecture in LectureDataManager.shared.GetLectures()
        {
            for i in 0...Int(arc4random_uniform(4))
            {
                if i == 0 {
                    continue
                }
            
                let goajae = Goajae()
                goajae.completed = false
                goajae.id = GoajaeDataManager.shared.GetNewId()
                goajae.lectureId = lecture.id
                goajae.memo = "메모메모 : " + lecture.name
                goajae.title = "\(lecture.name) 과제 \(i)"
                
                let date = Date()
                goajae.timeEnd = date
                
                goajaes.append(goajae)
            }
        }
    }
    
    public func Save()
    {
        //TODO
    }
    
    public func GetGoajaes (lecture:Lecture) -> [Goajae]
    {
        return GetGoajaes(lectureId: lecture.id)
    }
    
    public func GetGoajaes (lectureId:Int) -> [Goajae]
    {
        var ret:[Goajae] = []
        for goajae in goajaes
        {
            if goajae.lectureId == lectureId
            {
                ret.append(goajae)
            }
        }
        return ret
    }
    
    public func GetGoajaes () -> [Goajae]
    {
        return goajaes
    }
    
    public func AddGoajae (goajae:Goajae)
    {
        goajaes.append(goajae)
        Save()
    }
    
    public func EditGoajae (goajae:Goajae)
    {
        goajaes = goajaes.filter({ (item) -> Bool in
            item.id != goajae.id
        })
        AddGoajae(goajae: goajae)
    }
}
