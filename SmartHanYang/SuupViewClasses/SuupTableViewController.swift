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
    var gonggangIndexes:[Int] = []
    
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
                    gonggangIndexes.append(i)
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
        return isGonggangAndOriginIndex(i:indexPath[1]).0 ? 41 : 78
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        

        {
            return []
        }
        
        let hyugang = UITableViewRowAction(style: .normal, title: "휴강") { action, index in

        }
        hyugang.backgroundColor = .lightGray
        
        let bogang = UITableViewRowAction(style: .normal, title: "보강") { action, index in
      
        }
        bogang.backgroundColor = UIColor(red:0.29, green:0.49, blue:0.75, alpha:1.0)
        let goajae = UITableViewRowAction(style: .normal, title: "과제") { action, index in
         
        }
        goajae.backgroundColor = UIColor(red:0.37, green:0.70, blue:0.62, alpha:1.0)
        
        return [goajae, hyugang, bogang]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todayLectures.count + gonggangIndexes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath[1]
        
        let condition =  isGonggangAndOriginIndex(i:i)
        let originIndex = condition.1
        
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
        var originIndex = i
        var index = 0
        var isGongang = false
        while index <= i
        {
            isGongang = gonggangIndexes.contains(index)
            if isGongang
            {
                originIndex -= 1
            }
            index += 1
        }
        return (isGongang, originIndex)
    }

}
