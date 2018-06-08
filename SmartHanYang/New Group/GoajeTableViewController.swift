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
    
    @IBOutlet var tableOutlet: UITableView!
    

    override func viewDidLoad() {
        goajes = GoajeDataManager.shared.GetGoajes()
        GoajeDataManager.shared.addUpdateEventListener {
            self.goajes = GoajeDataManager.shared.GetGoajes()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "삭제") {(action, view, completion) in
            GoajeDataManager.shared.RemoveGoaje(id: self.goajes[indexPath.row].id)
            self.goajes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .red
        
        return action
    }
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "수정") {(action, view, completion) in
            let _child = self.storyboard?.instantiateViewController(withIdentifier: "addGoajeView") as? AddGoajeViewController?;
            if let child = _child! {
                child.modalPresentationStyle = .overCurrentContext
                self.present(child, animated: true, completion: nil)
                child.EditGoaje(goaje: self.goajes[indexPath.row])
            }
            completion(false)
        }
        action.backgroundColor = .gray
        
        return action
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goajes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "goajeCell", for: indexPath) as! GoajeTableViewCell
        
        cell.SetGoaje(goaje: goajes[indexPath.row])
        
        return cell
    }

}
