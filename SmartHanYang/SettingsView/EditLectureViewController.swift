//
//  EditLectureViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 14..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class EditLectureViewController: UITableViewController {
    var lecture:Lecture?
    var times:[LectureTimeTable]?
    
    @IBAction func cancel()
    {
        LectureDataManager.shared.dispatchEvent()
        self.dismiss(animated: true)
    }
    @IBAction func save()
    {
        if lecture == nil {
            lecture = Lecture(name : "")
        }
        UpdateLecture()
        
        LectureDataManager.shared.AddLecture(lecture: lecture!)
        
        self.dismiss(animated: true)
    }
    
    public func SetLecture(lecture:Lecture)
    {
        self.lecture = lecture
        
        //self.tableView.reloadData()
    }
    
    func UpdateLecture()
    {
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextCell
        lecture?.name = nameCell.textField.text!
        
        let professorCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextCell
        lecture?.professor = professorCell.textField.text!
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if lecture == nil {
            lecture = Lecture(name : "")
        }
        LectureDataManager.shared.addUpdateEventListener(key:"EditLectureViewController") {
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if lecture != nil && LectureDataManager.shared.GetLectures().contains(lecture!) {
            return 4
        }
        else {
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 2 {
            return 1
        }
        else if section == 2{
            return lecture!.timeTables.count + 1
        }
        else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < lecture!.timeTables.count && indexPath.section >= 2
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Easy.ShowAlert(me: self, title: "정말 수업을 삭제하시겠습니까?", message: "") { (b) in
                if b{
                    self.lecture!.timeTables.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    LectureDataManager.shared.Save(dispatch: false)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as? TextCell
            
            cell?.textField?.placeholder = "수업 이름"
            cell?.textField?.text = lecture?.name
            return cell!
        }
        else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as? TextCell
            
            cell?.textField?.placeholder = "교수님"
            cell?.textField?.text = lecture?.professor
            return cell!
        }
        else if indexPath.section == 2 {
            
            if lecture != nil && indexPath.row < lecture!.timeTables.count {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath)
                cell.textLabel!.text = lecture!.timeTables[indexPath.row].GetDayAndTimeText()
                cell.detailTextLabel!.text = lecture!.timeTables[indexPath.row].room
                return cell
            }
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "addTimeCell", for: indexPath)
                return cell
            }
        }
        else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "delCell", for: indexPath) as? UITableViewCell
            return cell!
        }
        // Configure the cell...

        return tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            
            UpdateLecture()
            if lecture != nil && indexPath.row < lecture!.timeTables.count {
                let _child = self.storyboard?.instantiateViewController(withIdentifier: "editTimeView") as? EditTimeTableViewController?;
                if let child = _child! {
                    self.show(child, sender: nil)
                    child.loadFunc = {
                        child.Set(lecture: self.lecture!)
                        child.Set(lectureTimeTable: self.lecture!.timeTables[indexPath.row])
                    }
                }
            }
            else {
                
                let _child = self.storyboard?.instantiateViewController(withIdentifier: "editTimeView") as? EditTimeTableViewController?;
                if let child = _child! {
                    self.show(child, sender: nil)
                    child.loadFunc = {
                        child.Set(lecture: self.lecture!)
                        let ltt = LectureTimeTable()
                        ltt.weekDay = 2
                        child.Set(lectureTimeTable: ltt)
                    }
                }
            }
        }
        else if indexPath.section == 3 {
            Easy.ShowAlert(me: self, title: "정말 수업을 삭제하시겠습니까?", message: "") { (b) in
                if b{
                    LectureDataManager.shared.RemoveLecture(id: self.lecture!.id,withSave: true)
                    self.cancel()
                }
            }
        }
    }
}
