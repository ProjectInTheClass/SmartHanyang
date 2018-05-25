//
//  SuupTableViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 10..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class SuupTableViewController: UITableViewController {
    var todayLectures:[LectureTimeTable] = []
    var gonggangIndexes:[Float] = []
    
    override func viewDidLoad() {
        
        LectureDataManager.shared.addUpdateEventListener {
            self.update()
            self.tableView.reloadData()
        }
        super.viewDidLoad()
        update()
    }
    
    func update()
    {
        todayLectures = LectureDataManager.shared.GetTodayLectures()
        gonggangIndexes.removeAll()
        var prev:LectureTimeTable? = nil
        
        for (i,l) in todayLectures.enumerated()
        {
            if let p = prev
            {
                let t = l.timeStart - p.timeEnd
                if t > 0
                {
                    gonggangIndexes.append(Float(i)-0.5)
                }
            }
            prev = l
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath[1] == 0{
            return 500
        }
        
        return isGonggangAndOriginIndex(i:indexPath[1]).0 ? 41 : 78
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let checker = isGonggangAndOriginIndex(i: editActionsForRowAt[1])
        if checker.0
        {
            return []
        }
        
        let time = todayLectures[checker.1]
        
        let hyugang = UITableViewRowAction(style: .normal, title: "휴강") { action, index in
            let _child = self.storyboard?.instantiateViewController(withIdentifier: "editSuupViewController") as? EditSuupViewController?;
            if let child = _child! {
                child.modalPresentationStyle = .overCurrentContext
                self.present(child, animated: true, completion: nil)
                child.lecturePicker.select(lectureId: time.lectureId)
                child.typeSelector.selectedSegmentIndex = 0
                child.ShowHyugangView()
            }
        }
        hyugang.backgroundColor = .lightGray
        
        let bogang = UITableViewRowAction(style: .normal, title: "보강") { action, index in
            let _child = self.storyboard?.instantiateViewController(withIdentifier: "editSuupViewController") as? EditSuupViewController?;
            if let child = _child! {
                child.modalPresentationStyle = .overCurrentContext
                self.present(child, animated: true, completion: nil)
                child.lecturePicker.select(lectureId: time.lectureId)
                child.typeSelector.selectedSegmentIndex = 1
                child.ShowBogangView()
            }
        }
        bogang.backgroundColor = UIColor(red:0.29, green:0.49, blue:0.75, alpha:1.0)
        let goajae = UITableViewRowAction(style: .normal, title: "과제") { action, index in
            print("과제 추가")
        }
        goajae.backgroundColor = UIColor(red:0.37, green:0.70, blue:0.62, alpha:1.0)
        
        return [goajae, hyugang, bogang]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todayLectures.count + gonggangIndexes.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath[1]
        
        let condition =  isGonggangAndOriginIndex(i:i)
        let originIndex = condition.1
        
        if i == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timetable", for: indexPath) as! TimeTableView
            return cell
        }
        
        if condition.0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gonggangCell", for: indexPath) as! GonggangCell
            
            cell.SetHyugangInfor(time1: todayLectures[originIndex], time2: todayLectures[originIndex+1] )
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "suupCell", for: indexPath) as! SuupTableViewCell
            
            let lecture = todayLectures[originIndex]
            cell.SetTimeTable(table: lecture)
            return cell
        }
    }
    
    func isGonggangAndOriginIndex(i:Int) -> (Bool,Int)
    {
        if i == 0
        {
            return (true, -1)
        }
        var input = i-1
        
        var isGongang = false
        for j in gonggangIndexes {
            isGongang = false
            if Float(input) > j{
                input -= 1
                if Float(input) < j{
                    isGongang = true
                    break
                }
            }
        }
        return (isGongang, input)
    }

}
