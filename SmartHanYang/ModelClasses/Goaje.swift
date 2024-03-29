//
//  Goajae.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 14..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation


public class Goaje : Codable
{
    var id:Int
    var title:String
    var memo:String
    var timeEnd:Date
    var completed:Bool
    var lectureId:Int?
    
    init() {
        id = GoajeDataManager.shared.GetNewId()
        title = "무제"
        memo = ""
        completed = false
        timeEnd = Date()
    }
    init(title:String){
        id = GoajeDataManager.shared.GetNewId()
        self.title = title
        memo = ""
        completed = false
        timeEnd = Date()
    }
}



