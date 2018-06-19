//
//  TextCell.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 15..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell,UITextFieldDelegate {
    
    
    @IBOutlet weak public var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if textField != nil {
            textField.delegate = self
        }
        else {
            print("TextCell은 textField가 필요합니다!")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return false
    }

}
