//
//  ResataurantManager.swift
//  SmartHanYang
//
//  Created by ㅇㅈㅇ on 2018. 5. 31..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation

class innerRestaurantManager
{
    static let fileName: String = "innerRestaurants.brch"
    
    static let documentPath = NSSearchPathForDirectoriesInDomains(
        FileManager.SearchPathDirectory.documentDirectory,
        FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    let filePath = "\(documentPath)/" + fileName
    
    func load() {
        if FileManager.default.fileExists(atPath: filePath) {
                if let unarchArray = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [InnerRestaurant] {
                        innerRestaurants = unarchArray
                } else {
                    innerRestaurants.removeAll()
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
                    //todo 추가적인 데이터파싱이 필요함
                    
                    innerRestaurants.append(studentRestaurant)
                    innerRestaurants.append(facultyRestaurant)
                    innerRestaurants.append(saragbang)
                    innerRestaurants.append(newFacultyRestaurant)
                    innerRestaurants.append(newStudentRestaurant)
                    innerRestaurants.append(dormRestaurant1)
                    innerRestaurants.append(dormRestaurant2)
                    innerRestaurants.append(haengwonPark)
            }
        }
    }
    
    func save() {
        NSKeyedArchiver.archiveRootObject(innerRestaurants, toFile: filePath)
    }
}

class outerRestaurantManager {
    static let fileName: String = "outerRestaurants.brch"
    
    static let documentPath = NSSearchPathForDirectoriesInDomains(
        FileManager.SearchPathDirectory.documentDirectory,
        FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    let filePath = "\(documentPath)/" + fileName
    
    func load() {
        if FileManager.default.fileExists(atPath: filePath) {
            if let unarchArray = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [OuterRstaurant] {
                outerRestaurants = unarchArray
            } else {
                outerRestaurants.removeAll()
                //
                
            }
        }
    }
    
    func save() {
        NSKeyedArchiver.archiveRootObject(outerRestaurants, toFile: filePath)
    }
}
