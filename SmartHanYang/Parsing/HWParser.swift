//
//  HWParser.swift
//  SmartHanYang
//
//  Created by gameegg on 2018. 5. 11..
//  Copyright © 2018년 graph. All rights reserved.
//


import Foundation
let key = "2s7Ymz8gu7_8XuTEeMFVmxJBLmyNNL4n8"
let secret = "8XuXAs8K37ejtYqvsEue2p"

let url = URL(string: "https://api.ote-godaddy.com/v1/domains/available?domain=example.guru&checkType=FULL")


let publicToken = "/public_token.json?t=mobile"


var request = URLRequest(url: url!)


func doParse()
{
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("sso-key \(key):\(secret)", forHTTPHeaderField: "Authorization")
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        guard error == nil else {
            print(error!)
            return
        }
        guard let data = data else {
            print("Data is empty")
            return
        }
        
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        print(json)
    }

    task.resume()
}
