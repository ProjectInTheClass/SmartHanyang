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

    @IBOutlet weak var dateField: UITextField!
    
    let picker = UIDatePicker()
    @IBAction func saveAction(_ sender: Any) {
        if titleOutlet.text != "" {
            delegate?.saveGoajae(title: titleOutlet.text!)
        }
    }
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var detailOutlet: UITextView!
    
    var delegate: SaveGoajae?
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        toolbar.setItems([done], animated: false)
        
        dateField.inputAccessoryView = toolbar
        dateField.inputView = picker
        
        picker.datePickerMode = .date
    }
    
    func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        dateField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
