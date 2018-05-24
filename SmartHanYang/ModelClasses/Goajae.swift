//
//  Goajae.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 14..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation


public class Goajae
{
    var id:Int //
    var title:String // 과목
    var memo:String //  자세내용
    var timeEnd:Date //데드라인
    var completed:Bool //완성여부
    var lectureId:Int? //
    
    init() {
        id = 0
        title = ""
        memo = ""
        completed = false
        timeEnd = Date()
    }
}



