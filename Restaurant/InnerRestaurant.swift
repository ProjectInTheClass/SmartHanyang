//
//  innerRestaurant.swift
//  SmartHanYang
//
//  Created by ㅇㅈㅇ on 2018. 5. 31..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation

class InnerRestaurant: NSObject, NSCoding {

    
    let name: String
    let location: String
    let openTime: String
    var meals: [[Meal]] //첫번째 value는 요일, 두번째 value는 index
    
    init(name: String, location: String, openTime: String) {
        self.name = name
        self.location = location
        self.openTime = openTime
        meals = Array(repeating: [Meal](), count: 7) // 월요일부터 일요일까지 7개
    }
    
    func addMeal(day: Int, meal: Meal) {
        meals[day].append(meal)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name,forKey: "name")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(openTime, forKey: "openTime")
        aCoder.encode(meals, forKey: "meals")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.location = aDecoder.decodeObject(forKey: "location") as! String
        self.openTime = aDecoder.decodeObject(forKey: "openTime") as! String
        self.meals = aDecoder.decodeObject(forKey: "meals") as! [[Meal]]
    }
}

var studentRestaurant = InnerRestaurant(name: "학생식당",
                                        location: "학생복지관 3층",
                                        openTime: "평일: 중식/석식(9:30 ~ 18:30)\n분식(9:30 ~ 11:30 / 14:00 ~ 17:00\n토요일: 중식(10:00 ~ 14:00")
var facultyRestaurant = InnerRestaurant(name: "교직원식당",
                                        location: "생활과학관 7층",
                                        openTime: "평일: 중식(11:30 ~ 14:00)\n석식(17:00 ~ 18:30)\n토요일: 중식(11:30 ~ 13:30)")
var saragbang = InnerRestaurant(name: "사랑방",
                                location: "학생회관 3층",
                                openTime: "중식: 11:00 ~ 15:00\n석식: 16:30 ~ 18:30")
var newFacultyRestaurant = InnerRestaurant(name: "신교직원식당",
                                           location: "신소재공학관 7층",
                                           openTime: "평일: 중식(11:30 ~ 13:30)\n석식(17:30 ~ 19:00)\n토요일: 중식(11:30 ~ 13:30)")
var newStudentRestaurant = InnerRestaurant(name: "신학생식당",
                                           location: "신소재공학관 지하 1층",
                                           openTime: "중식: 11:30 ~ 13:30\n석식: 17:00 ~ 18:40")
var dormRestaurant1 = InnerRestaurant(name: "제1생활관식당",
                                      location: "제1학생생활관 1층",
                                      openTime: "조식: 7:30 ~ 9:00(주말: 8:00 ~ 9:00)\n중식: 12:00 ~ 13:30\n석식: 17:30 ~ 18:30")
var dormRestaurant2 = InnerRestaurant(name: "제2색환관식당",
                                      location: "제2생활관",
                                      openTime: "조식: 7:30 ~ 9:00\n중식: 12:00 ~ 13:30\n석식: 17:30 ~ 19:00")
var haengwonPark = InnerRestaurant(name: "행원파크",
                                   location: "행원파크 지하 1층",
                                   openTime: "[교직원코너 및 학생코너] 11:30 ~ 19:00(18:50 주문마감)\n[분식코너] 14:00 ~ 18:00")

var innerRestaurants =
[
    studentRestaurant,
    facultyRestaurant,
    saragbang,
    newFacultyRestaurant,
    newStudentRestaurant,
    dormRestaurant1,
    dormRestaurant2,
    haengwonPark
]




