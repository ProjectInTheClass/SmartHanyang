//
//  File.swift
//  SmartHanYang
//
//  Created by ㅇㅈㅇ on 2018. 5. 31..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation
import UIKit

class OuterRstaurant: NSObject, NSCoding {
    
    var name: String
    var meals: [Meal]
    
    init(name: String, meals: [Meal]) {
        self.name = name
        self.meals = meals
    }
    
    init(name: String) {
        self.name = name
        self.meals = Array<Meal>()
    }
    
    func addMeal(menu: String) {
        let aMeal = Meal(menu: menu)
        self.meals.append(aMeal)
    }
    
    func addMeal(image: UIImage, menu: String) {
        let aMeal = Meal(image: image, menu: menu)
        self.meals.append(aMeal!)
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.meals, forKey: "meals")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.meals = aDecoder.decodeObject(forKey: "meals") as! [Meal]
    }
    

}

var outerRestaurants = Array<OuterRstaurant>()


