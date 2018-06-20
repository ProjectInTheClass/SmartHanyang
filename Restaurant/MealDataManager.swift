//
//  MealDataManager.swift
//  SmartHanYang
//
//  Created by ㅇㅈㅇ on 2018. 6. 20..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation
import UIKit

class MealDataManager
{
    static let fileName: String = "meals.brch"
    
    static let documentPath = NSSearchPathForDirectoriesInDomains(
        FileManager.SearchPathDirectory.documentDirectory,
        FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    let filePath = "\(documentPath)/" + fileName
    
    static let shared = MealDataManager();
    var meals: [Meal] = [];
    var listeners:[String:()->Void] = [:]
    
    init() {
        
    }
    
    public func addUpdateEventListener(key:String,f:@escaping ()->Void)
    {
        listeners[key] = f
    }
    
    public func removeEventListener(key:String)
    {
        listeners.removeValue(forKey: key)
    }
    
    public func dispatchEvent()
    {
        for f in listeners
        {
            f.1()
        }
    }


    
    public func load()
    {
        meals.removeAll()
        print(filePath)
        //위에처럼 따로따로 하지 않고 전체를 아카이브를 이용해서 저장하고 로드
        if FileManager.default.fileExists(atPath: filePath) {
            if let unarchArray = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Meal] {
                self.meals = unarchArray
                
            }
        }
        else{
                let photo1 = UIImage(named: "meal1")
                let photo2 = UIImage(named: "meal2")
                let photo3 = UIImage(named: "meal3")
                
                guard let meal1 = Meal(name: "행원파크", photo: photo1, rating: 3) else {
                    fatalError("Unable to instantiate meal1")
                }
                
                guard let meal2 = Meal(name: "신학생식당", photo: photo2, rating: 3) else {
                    fatalError("Unable to instantiate meal2")
                }
                
                guard let meal3 = Meal(name: "교직원식당", photo: photo3, rating: 5) else {
                    fatalError("Unable to instantiate meal2")
                }
                
                MealDataManager.shared.meals.append(meal1)
                MealDataManager.shared.meals.append(meal2)
                MealDataManager.shared.meals.append(meal3)
                
                MealDataManager.shared.save()
                MealDataManager.shared.load()
        }
    }

    
    public func save(dispatch:Bool = true)
    {
        if dispatch {
            self.dispatchEvent()
        }
        
        NSKeyedArchiver.archiveRootObject(meals, toFile: filePath)
    }
    
    public func getMeal(index:Int) -> Meal?
    {
        return meals[index]
    }
    
    public func getMeals() -> [Meal]
    {
        return meals
    }

    
    public func addMeal(aMeal: Meal)
    {
        meals.append(aMeal)
        save()
    }
    
    public func removeMeal(index:Int, withSave:Bool = true)
    {
        meals.remove(at: index)
        if withSave{
            save()
        }
    }
    
    public func DeleteAll()
    {
        meals = []
        save()
    }
}
