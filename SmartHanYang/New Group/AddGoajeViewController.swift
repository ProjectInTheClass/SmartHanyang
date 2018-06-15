//
//  AddGoajeViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 7..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class AddGoajeViewController: UITableViewController
{
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var lecturePicker: LecturePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var goaje:Goaje?
    
    @IBAction func Cancel()
    {
        self.dismiss(animated: true)
    }
    
    @IBAction func Done()
    {
        var isEditMode = false
        var goajeF:Goaje;
        if goaje == nil{
            goajeF = Goaje()
        }
        else{
            goajeF = goaje!
            isEditMode = true
        }
        
        if let title = titleLabel.text{
            if title.count > 0{
                goajeF.title = title
            }
            else{
                goajeF.title = "그냥 과제"
            }
        }
        else{
            goajeF.title = "그냥 과제"
        }
        goajeF.lectureId = lecturePicker.selectedLectureId
        
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: datePicker.date)!
        goajeF.timeEnd = date
        if isEditMode {
            GoajeDataManager.shared.EditGoaje(goaje: goajeF)
            GoajeDataManager.shared.dispatchEvent();
        }
        else {
            GoajeDataManager.shared.AddGoaje(goaje:goajeF)
        }
        self.dismiss(animated: true)
    }
    
    public func EditGoaje(goaje:Goaje)
    {
        self.goaje = goaje
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ggg = goaje {
            lecturePicker.select(lectureId: ggg.lectureId!)
            titleLabel.text = ggg.title
            datePicker.setDate(ggg.timeEnd, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
