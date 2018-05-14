//
//  SuupTableViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 10..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class SuupTableViewController: UITableViewController {
    var tableData:Array<Lecture> = Array();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let softwareStudio1 = Lecture(name: "소프트웨어스튜디오1")
        softwareStudio1.professor = "윤성관"
        softwareStudio1.AddTime(day: 4, room: "IT/BT 509", timeStart: 16, timeEnd: 19)
        softwareStudio1.AddTime(day: 5, room: "IT/BT 509", timeStart: 16, timeEnd: 18)
        
        
        let storytelling = Lecture(name:"디지털스토리텔링의이해")
        storytelling.professor = "김은정"
        storytelling.AddTime(day: 2, room: "인문관 B104", timeStart: 13.5, timeEnd: 15.5)
        
        
        let automata = Lecture(name:"오토마타")
        automata.professor = "박희진"
        automata.AddTime(day:3, room:"IT/BT 508", timeStart: 14.5, timeEnd: 16)
        automata.AddTime(day:5, room:"IT/BT 508", timeStart: 14.5, timeEnd: 16)
        
        
        let os = Lecture(name:"운영체제")
        os.professor = "유민수"
        os.AddTime(day: 3, room: "IT/BT 501", timeStart: 16, timeEnd: 18)
        os.AddTime(day: 5, room: "IT/BT 503", timeStart: 10, timeEnd: 12)
        
        
        let soundTec = Lecture(name: "아트테크놀로지사운드")
        soundTec.professor = "정은주"
        soundTec.AddTime(day: 4, room: "제2공학관 PC1", timeStart: 10, timeEnd: 13)
        
        
        let computerStructure = Lecture(name:"컴퓨터구조")
        computerStructure.professor = "박영준"
        computerStructure.AddTime(day: 4, room: "IT/BT 207", timeStart: 13, timeEnd: 14.5)
        computerStructure.AddTime(day: 5, room: "IT/BT 207", timeStart: 13, timeEnd: 14.5)
        
        tableData.append(softwareStudio1);
        tableData.append(storytelling);
        tableData.append(automata);
        tableData.append(os);
        tableData.append(soundTec);
        tableData.append(computerStructure);
        
        
        

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "월";
        case 1:
            return "화";
        case 2:
            return "수";
        case 3:
            return "목";
        case 4:
            return "금";
        default:
            return "?";
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GetDayLecture(sectionNumber: section).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suupCell", for: indexPath) as! SuupTableViewCell
        
        // Configure the cell...
        print(indexPath)
        let lectures = GetDayLecture(sectionNumber: indexPath[0]).sorted(by: {
            $0.timeTables![indexPath[0]+1]!.timeStart! < $1.timeTables![indexPath[0]+1]!.timeEnd!
            
        })
        
        let lecture = lectures[indexPath[1]]
        cell.titleLabel.text = lecture.name
        cell.timeLabel.text = lecture.timeTables![indexPath[0]+1]!.GetSubtitle()
        return cell
    }
    
    func GetDayLecture(sectionNumber:Int) -> [Lecture]
    {
        return tableData.filter({$0.timeTables!.keys.contains(sectionNumber+1)})
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
