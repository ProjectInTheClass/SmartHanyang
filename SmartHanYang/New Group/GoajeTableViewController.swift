//
//  GoajeTableViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 1..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class GoajeTableViewController: UITableViewController {
    
    var goajes:[Goaje] = []
    var showCompletedGoaje = false
    
    @IBOutlet var tableOutlet: UITableView!
    

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        goajes = GoajeDataManager.shared.GetGoajes()
        GoajeDataManager.shared.addUpdateEventListener(key:"GoajeTableViewController") {
            self.goajes = GoajeDataManager.shared.GetGoajes()
            self.tableView.reloadData()
        }
        
        self.editButtonItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        GoajeDataManager.shared.removeEventListener(key:"GoajeTableViewController")
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "삭제") { (action, indexPath) in
            GoajeDataManager.shared.RemoveGoaje(id: self.goajes[indexPath.row].id)
            self.goajes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let edit = UITableViewRowAction(style: .destructive, title: "수정") {(action, indexPath) in
            let _child = self.storyboard?.instantiateViewController(withIdentifier: "addGoajeView") as? UINavigationController?;
            if let child = _child! {
                //                self.navigationController?.show(child, sender: self)
                self.present(child, animated: true, completion: nil)
                let g = child.viewControllers.first as! AddGoajeViewController?
                g?.EditGoaje(goaje: self.goajes[indexPath.row])
            }
        }
        edit.backgroundColor = .gray
        return [delete,edit]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < goajes.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goajes.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == goajes.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addGoaje", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "goajeCell", for: indexPath) as! GoajeTableViewCell
        
        cell.SetGoaje(goaje: goajes[indexPath.row])
        
        return cell
    }

}
