//
//  LectureManagerViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 14..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class LectureManagerViewController: UITableViewController {

    var lectures:[Lecture] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lectures = LectureDataManager.shared.GetLectures()
        self.tableView.reloadData()
        LectureDataManager.shared.addUpdateEventListener(key: "lectureManagerViewController") {
            self.lectures = LectureDataManager.shared.GetLectures()
            self.tableView.reloadData()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        LectureDataManager.shared.removeEventListener(key: "lectureManagerViewController")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectures.count + 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _child = self.storyboard?.instantiateViewController(withIdentifier: "editLecture") as? UINavigationController?;
        if let child = _child! {
            child.modalPresentationStyle = .overFullScreen
            let v = child.childViewControllers.first as! EditLectureViewController
            self.present(child, animated: true, completion:{
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            if indexPath.row < lectures.count {
                v.SetLecture(lecture: self.lectures[indexPath.row])
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < lectures.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
            cell.textLabel?.text = lectures[indexPath.row].name
            cell.detailTextLabel?.text = lectures[indexPath.row].professor
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < lectures.count
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Easy.ShowAlert(me: self, title: "정말 수업을 삭제하시겠습니까?", message: "") { (b) in
                if b{
                    LectureDataManager.shared.RemoveLecture(id: self.lectures[indexPath.row].id,withSave: false)
                    self.lectures = LectureDataManager.shared.GetLectures()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
}
