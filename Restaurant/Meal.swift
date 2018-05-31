//
//  Meal.swift
//  SmartHanYang
//
//  Created by ㅇㅈㅇ on 2018. 5. 31..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation
import UIKit


class Meal: NSObject, NSCoding {
    var image: UIImage?
    var menu: String
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: "image")
        aCoder.encode(menu, forKey: "menu")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.image = aDecoder.decodeObject(forKey: "image") as! UIImage
        self.menu = aDecoder.decodeObject(forKey: "menu") as! String
    }
    
    init?(image:UIImage, menu:String) {
        self.image = image
        self.menu = menu
    }
    
    init(menu: String) {
        self.image = nil
        self.menu = menu
    }
}
