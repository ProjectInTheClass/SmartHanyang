//
//  GoajaeTableViewCell.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 1..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit
import BEMCheckBox

class GoajeTableViewCell: UITableViewCell,BEMCheckBoxDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var lectureNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkbox: BEMCheckBox!
    
    var goaje:Goaje?
    
    public func SetGoaje(goaje:Goaje) {
        self.goaje = goaje
        
        titleLabel.text = goaje.title
        lectureNameLabel.text = LectureDataManager.shared.GetLecture(id: goaje.lectureId!)?.name
        
        dateLabel.text = Easy.DateToText(date: goaje.timeEnd)
        
        
        let a = EasyCalendar.DDay(from:Date() , to: goaje.timeEnd)
        
        if a >= 0 {
            dDayLabel.text = "D-\(a)"
        }
        else {
            dDayLabel.text = "늦음"
            dDayLabel.textColor = UIColor.init(hexString: "#990000")
        }
        
        
        checkbox.onAnimationType = .fill
        checkbox.offAnimationType = .bounce
        
        checkbox.onFillColor = UIColor.init(hexString: "#007aff")
        checkbox.onCheckColor = .white
        
        checkbox.delegate = self
        
        if let goaje = self.goaje {
            checkbox.on = goaje.completed
            
            if goaje.completed {
                dDayLabel.text = "완료"
            }
        }
        ShowCompleted(compledted:goaje.completed)
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        goaje?.completed = checkbox.on
        if let goaje = self.goaje {
            GoajeDataManager.shared.EditGoaje(goaje: goaje)
            ShowCompleted(compledted:goaje.completed)
        }
    }
    
    
    func ShowCompleted(compledted:Bool)
    {
        let transition = {(label:UILabel) -> Void in
            UIView.transition(with: label, duration: 0.4, options: .transitionCrossDissolve, animations: {
                label.isEnabled = !compledted
            }, completion: nil)
        }
        transition(titleLabel)
        transition(dDayLabel)
        transition(lectureNameLabel)
        transition(dateLabel)
    }
    
    

}