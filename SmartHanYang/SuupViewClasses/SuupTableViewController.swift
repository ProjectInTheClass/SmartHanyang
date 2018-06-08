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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        super.viewDidLoad()
        update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: UITableViewScrollPosition.top, animated: false)
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
        
        DispatchQueue.main.async {
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 44
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath[1] == 0{
            var h = UIScreen.main.bounds.height
            h -= UIApplication.shared.statusBarFrame.size.height
            h -= self.navigationController?.navigationBar.frame.height ?? 0.0
            h -= self.tabBarController?.tabBar.frame.size.height ?? 0.0
            
            return h
        }
        let aa = isGonggangAndOriginIndex(i:indexPath[1])
        if aa.1 > todayLectures.count - 1 {
            var h = UIScreen.main.bounds.height
            h -= CGFloat(gonggangIndexes.count * 41 + todayLectures.count * 78)
            h -= UIApplication.shared.statusBarFrame.size.height
            h -= self.navigationController?.navigationBar.frame.height ?? 0.0
            h -= self.tabBarController?.tabBar.frame.size.height ?? 0.0
            
            return max(30, h)
        }
        
        return aa.0 ? 41 : 78
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
            let _child = self.storyboard?.instantiateViewController(withIdentifier: "addGoajeView") as? AddGoajeViewController?;
            if let child = _child! {
                child.modalPresentationStyle = .overCurrentContext
                self.present(child, animated: true, completion: nil)
                child.lecturePicker.select(lectureId: time.lectureId)
            }
        }
        goajae.backgroundColor = UIColor(red:0.37, green:0.70, blue:0.62, alpha:1.0)
        
        return [goajae, hyugang, bogang]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todayLectures.count + gonggangIndexes.count + 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath[1]
        
        let condition =  isGonggangAndOriginIndex(i:i)
        let originIndex = condition.1
        
        if i == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "timetable", for: indexPath) as! TimeTableView
            cell.DoIt()
            return cell
        }
        
        if condition.1 > todayLectures.count-1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell", for: indexPath)
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
        if input > todayLectures.count-1 {
            isGongang = true
        }
        return (isGongang, input)
    }

}
