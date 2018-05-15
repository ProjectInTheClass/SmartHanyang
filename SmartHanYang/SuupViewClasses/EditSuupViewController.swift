//
//  EditSuupViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 15..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class EditSuupViewController: UIViewController
{
    @IBOutlet weak var bogangView: UIView!
    @IBOutlet weak var hygangView: UIView!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    @IBOutlet weak var typeSelector: UISegmentedControl!
    @IBOutlet weak var lecturePicker: LecturePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bogangStartTime: UIDatePicker!
    @IBOutlet weak var bogangEndTime: UIDatePicker!
    @IBOutlet weak var hygangTimePicker: LectureTimePicker!
    
    @IBAction func cancel()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done()
    {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func typeChanged(sender:UISegmentedControl)
    {
        switch typeSelector.selectedSegmentIndex {
        case 0:
            ShowHyugangView()
            break
        case 1:
            ShowBogangView()
            break
        default:
            break
        }
    }
    
    public func ShowBogangView()
    {
        hygangView.isHidden = true
        bogangView.isHidden = false
        
    }
    
    public func ShowHyugangView()
    {
        hygangView.isHidden = false
        bogangView.isHidden = true
        
    }
    
    public func InitLecture(lectureId:Int = -1)
    {
        let lectures = LectureDataManager.shared.GetLectures()
        if lectures.count == 0
        {
            let alertController = UIAlertController(title: "수업 정보가 없습니다! x_x",message: "먼저 수업을 추가해주세요~", preferredStyle: UIAlertControllerStyle.alert)
            
            //UIAlertActionStye.destructive 지정 글꼴 색상 변경
            let okAction = UIAlertAction(title: "네", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
                self.cancel()
            }
            alertController.addAction(okAction)
            self.present(alertController,animated: true,completion: nil)
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
