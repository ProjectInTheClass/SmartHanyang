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
        
        checkbox.onAnimationType = .fill
        checkbox.offAnimationType = .bounce
        
        checkbox.onFillColor = UIColor.init(hexString: "#007aff")
        checkbox.onCheckColor = .white
        
        checkbox.delegate = self
        
        checkbox.on = goaje.completed
            
        updateText()
        
        ShowCompleted(compledted:goaje.completed,withAnim:false)
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        goaje?.completed = checkbox.on
        if let goaje = self.goaje {
            GoajeDataManager.shared.EditGoaje(goaje: goaje)
            ShowCompleted(compledted:goaje.completed)
        }
    }
    
    
    func ShowCompleted(compledted:Bool, withAnim:Bool = true)
    {
        let transition = {(label:UILabel) -> Void in
            if withAnim {
                UIView.transition(with: label, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    label.isEnabled = !compledted
                    self.updateText()
                }, completion: nil)
            }
            else {
                label.isEnabled = !compledted
                self.updateText()
            }
        }
        transition(titleLabel)
        transition(dDayLabel)
        transition(lectureNameLabel)
        transition(dateLabel)
    }
    
    func updateText(){
        if self.goaje == nil {
            return
        }
        
        let a = EasyCalendar.DDay(from:Date() , to: self.goaje!.timeEnd)
        
        if a >= 0 {
            dDayLabel.text = "D-\(a)"
            dDayLabel.textColor = UIColor.black
        }
        else {
            dDayLabel.text = "늦음"
            dDayLabel.textColor = UIColor.init(hexString: "#990000")
        }
        
        if self.goaje!.completed {
            dDayLabel.text = "완료"
        }
    }
    

}
