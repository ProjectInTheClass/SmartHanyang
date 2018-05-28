//
//  CafeteriaTableViewController.swift
//  SmartHanYang
//
//  Created by 현경우 on 2018. 5. 27..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class CafeteriaTableViewController: UITableViewController {

    
    var cafeterias:[Cafeteria] = []
    var menuImages:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cafeterias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cafeteriaCell", for: indexPath) as! CafeteriaTableViewCell
        
        cell.menuImageLabel.image = UIImage(named: menuImages[indexPath.row] as! String)
        cell.menuLabel.text = cafeterias[indexPath.row].menu
        cell.priceLabel.text = cafeterias[indexPath.row].price
        
        return cell
    }
}

class Cafeteria {
    var menu:String
    var price:String?
    var time:String
    var position:String
    var name:String
    
    init(menu:String) {
        self.menu =  menu
        self.price = ""
        self.time = ""
        self.position = ""
        self.name = ""
    }
}
