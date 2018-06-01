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
        
        //TODO
        // 아래는 임시 테스트 코드!!!!
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
    }
    
    public func Save()
    {
        //TODO
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
        return goajes
    }
    
    public func AddGoaje (goaje:Goaje)
    {
        goajes.append(goaje)
        Save()
    }
    
    public func EditGoaje (goaje:Goaje)
    {
        goajes = goajes.filter({ (item) -> Bool in
            item.id != goaje.id
        })
        AddGoaje(goaje: goaje)
    }
}
