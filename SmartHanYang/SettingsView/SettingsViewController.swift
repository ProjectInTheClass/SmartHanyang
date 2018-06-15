//
//  SettingsViewController.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 6. 14..
//  Copyright © 2018년 graph. All rights reserved.
//

import UIKit
import WKZombie


class SettingsViewController: UITableViewController {
    fileprivate let url = URL(string: "https://m.hanyang.ac.kr/login.page")!
    
    
    @IBAction func DeleteAllData(_ sender: Any){
        Easy.ShowAlert(me: self, title: "데이터를 초기화합니다", message: "신학기가 시작되었나보군요") { (b) in
            if b {
                LectureDataManager.shared.DeleteAll()
                GoajeDataManager.shared.DeleteAll()
            }
        }
    }
    
    @IBAction func DataDownload(_ sender: Any) {
        
        let alertController = UIAlertController(title: "시간표 가져오기", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "ID"
            textField.textContentType = .username
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "PASSWORD"
            textField.textContentType = .password
            textField.isSecureTextEntry = true
        }
        let saveAction = UIAlertAction(title: "가져오기", style: .default, handler: { alert -> Void in
            let id = alertController.textFields![0] as UITextField
            let password = alertController.textFields![1] as UITextField
            
            if let idStr = id.text, let pwdStr = password.text {
                self.login(self.url, user: idStr, password: pwdStr)
            }
        })
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func login(_ url: URL, user: String, password: String) {
        print("username:'\(user)', password:'\(password)'")
        open(url)
            >>> get(by: .id("_username"))
            >>> setAttribute("value", value: user)
            >>> get(by: .id("_password"))
            >>> setAttribute("value", value: password)
            >>> execute("loginProc()")
            === handleResult1
        
    }
    func handleResult1(result: JavaScriptResult?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            execute("document.cookie")
                === self.handleResult2
        }
    }
    
    func handleResult2(result: JavaScriptResult?) {
        if let result = result
        {
            requestData(cookie: result, yoils: [2,3,4,5,6])
        }
    }
    
    func requestData(cookie:String, yoils:[Int])
    {
        for yoil in yoils
        {
            let my_yoil = yoil
            
            var cal = Calendar.current
            cal.timeZone = .current
            
            if let url = URL(string: "https://m.hanyang.ac.kr/haksa/sggu/sggu0001001.json?suup_year=\(cal.component(.year, from: Date()))&suup_term=10&yoil=\(my_yoil)&apiUrl%5B%5D=%2FHASA%2FA201300018.json"){
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue(cookie, forHTTPHeaderField: "Cookie")
                
                
                let session = URLSession.shared
                session.dataTask(with: request, completionHandler: { (returnData, response, error) -> Void in
                    if (error) != nil
                    {
                        //print("re-yoil")
                        self.requestData(cookie: cookie, yoils: [my_yoil])
                    }
                    else if returnData != nil
                    {
                        if let str = NSString(data: returnData!, encoding: String.Encoding.utf8.rawValue)
                        {
                            print(str)
                            print("gogo: \(my_yoil)")
                            ParseJson(json: str as String, yoil: my_yoil)
                        }
                    }
                }).resume()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
