//
//  SaveGoajaeController.swift
//  SmartHanYang
//
//  Created by 현경우 on 2018. 5. 24..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

protocol SaveGoajae {
    func saveGoajae(title: String)
}
class SaveGoajaeController: UIViewController {

    @IBAction func saveAction(_ sender: Any) {
        if titleOutlet.text != "" {
            delegate?.saveGoajae(title: titleOutlet.text!)
        }
    }
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var detailOutlet: UITextView!
    
    var delegate: SaveGoajae?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
