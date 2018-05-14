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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayLectures = LectureDataManager.shared.GetTodayLectures()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    */
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath[1]%2 == 0 ? 78 : 41
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        if editActionsForRowAt[1]%2 == 1
        {
            return nil
        }
        
        let hyugang = UITableViewRowAction(style: .normal, title: "휴강") { action, index in
            print("휴강 추가")
        }
        hyugang.backgroundColor = .lightGray
        
        let bogang = UITableViewRowAction(style: .normal, title: "보강") { action, index in
            print("보강 추가")
        }
        bogang.backgroundColor = UIColor(red:0.29, green:0.49, blue:0.75, alpha:1.0)
        let goajae = UITableViewRowAction(style: .normal, title: "과제") { action, index in
            print("과제 추가")
        }
        goajae.backgroundColor = UIColor(red:0.37, green:0.70, blue:0.62, alpha:1.0)
        
        return [goajae, hyugang, bogang]
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath[1]%2 == 0 ? 80 : 44
    }
    
    /*
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todayLectures.count * 2 - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath[1]
        
        if i%2 == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "suupCell", for: indexPath) as! SuupTableViewCell
        
            let lecture = todayLectures[i/2]
            cell.SetTimeTable(table: lecture)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gonggangCell", for: indexPath) as! GonggangCell
            
            
            cell.SetHyugangInfor(time1: todayLectures[(i-1)/2], time2: todayLectures[(i+1)/2] )
            return cell
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
