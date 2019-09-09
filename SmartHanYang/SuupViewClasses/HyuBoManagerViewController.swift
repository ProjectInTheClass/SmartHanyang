//
//  HyuBoManagerViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 20..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class HyuBoManagerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    var lecturesHyu:[Lecture] = []
    var lecturesBo:[Lecture] = []
    
    @IBAction func modeChanged(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
        let lectures = LectureDataManager.shared.GetLectures()
        
        lecturesHyu = lectures.filter({ (lec) -> Bool in
            HasHyu(lec)
        })
        
        lecturesBo = lectures.filter({ (lec) -> Bool in
            HasBo(lec)
        })
        
        LectureDataManager.shared.addUpdateEventListener(key: "hyuboManagerViewController") {
            self.tableView.reloadData()
        }
    }
    
    func GetHyu (_ n:Int) -> [Date]{
        let lec = lecturesHyu[n]
        var hyugangs:[Date] = []
        for t in lec.timeTables {
            for d in t.hyugangDays {
                hyugangs.append(d)
            }
        }
        return hyugangs
    }
    
    func GetBo (_ n:Int) -> [Date]{
        let lec = lecturesBo[n]
        var bogangs:[Date] = []
        for t in lec.bogangTimeTables {
            if t.bogangDay != nil {
                bogangs.append(t.bogangDay!)
            }
        }
        return bogangs
    }
    
    func HasHyu (_ lec:Lecture) -> Bool {
        var tmp = 0
        for t in lec.timeTables {
            tmp += t.hyugangDays.count
        }
        return tmp > 0
    }
    func HasBo (_ lec:Lecture)-> Bool {
        return lec.bogangTimeTables.count > 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if modeSelector.selectedSegmentIndex == 0 {
            return GetHyu(section).count
        }
        else {
            return GetBo(section).count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if modeSelector.selectedSegmentIndex == 0 {
            return lecturesHyu.count
        }
        else {
            return lecturesBo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let (lec,d) = GetData(indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = lec.name
        cell.detailTextLabel?.text = "\(Easy.DateToText(date: d))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let (lec,_) = GetData(indexPath)
        
        if editingStyle == .delete {
            Easy.ShowAlert(me: self, title: "정말 삭제하시겠습니까?", message: "") { (b) in
                if b{
                    if self.modeSelector.selectedSegmentIndex == 0 {
                        var index = 0
                        var targetIndex = -1
                        var tttt:LectureTimeTable?
                        for t in lec.timeTables {
                            for (i,_) in t.hyugangDays.enumerated() {
                                if index == indexPath.row {
                                    targetIndex = i
                                    tttt = t
                                    break
                                }
                                index += 1
                            }
                            if targetIndex >= 0 {
                                break
                            }
                        }
                        tttt?.hyugangDays.remove(at: targetIndex)
                    }
                    else {
                        var index = 0
                        var targetIndex = -1
                        for (i,t) in lec.bogangTimeTables.enumerated() {
                            if let _ = t.bogangDay {
                                if index == indexPath.row {
                                    targetIndex = i
                                    break
                                }
                                index += 1
                            }
                        }
                        lec.bogangTimeTables.remove(at: targetIndex)
                    }
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    LectureDataManager.shared.Save(dispatch: false)
                }
            }
        }
    }
    
    func GetData (_ indexPath:IndexPath) -> (Lecture,Date)
    {
        var lec:Lecture;
        var d:Date;
        if modeSelector.selectedSegmentIndex == 0 {
            lec = lecturesHyu[indexPath.section]
            d = GetHyu(indexPath.section)[indexPath.row]
        }
        else {
            lec = lecturesBo[indexPath.section]
            d = GetBo(indexPath.section)[indexPath.row]
        }
        return (lec,d)
    }
}
