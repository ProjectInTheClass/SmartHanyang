//
//  GoajaeTableViewCell.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 1..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit
import BEMCheckBox

class GoajeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var lectureNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkbox: BEMCheckBox!
    
    var goaje:Goaje?
    
    public func SetGoaje(goaje:Goaje) {
        titleLabel.text = goaje.title
        lectureNameLabel.text = LectureDataManager.shared.GetLecture(id: goaje.lectureId!)?.name
        
        dateLabel.text = Easy.DateToText(date: goaje.timeEnd)
        
        
        let a = EasyCalendar.DDay(from:Date() , to: goaje.timeEnd)
        dDayLabel.text = "D-\(a)"
        
        checkbox.onAnimationType = .fill
        checkbox.offAnimationType = .bounce
        
        let fill = checkbox.onCheckColor
        checkbox.onFillColor = fill
        checkbox.onCheckColor = .white
    }
    
    

}
