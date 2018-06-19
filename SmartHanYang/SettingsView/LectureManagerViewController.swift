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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lectures = LectureDataManager.shared.GetLectures()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectures.count + 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _child = self.storyboard?.instantiateViewController(withIdentifier: "editLecture") as? EditLectureViewController?;
        if let child = _child! {
            child.modalPresentationStyle = .overFullScreen
            self.present(child, animated: true, completion: nil)
            child.SetLecture(lecture: self.lectures[indexPath.row])
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
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
 
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "삭제") {(action, view, completion) in
            LectureDataManager.shared.RemoveLecture(id: self.lectures[indexPath.row].id)
            self.lectures.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .red
        
        return action
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("pp")
    }
    

}
