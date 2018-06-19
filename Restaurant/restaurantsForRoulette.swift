//
//  restaurantsForRoulette.swift
//  SmartHanYang
//
//  Created by ㅇㅈㅇ on 2018. 5. 31..
//  Copyright © 2018년 graph. All rights reserved.
//

import Foundation

class RestaurantsForRoulette {
    var names:[String]
    
    init() {
        names = Array<String>()
    }
    func update() {
        names.removeAll()
        
        for innerRestaurant in innerRestaurants {
            names.append(innerRestaurant.name)
        }
        for outerRestaurant in outerRestaurants {
            names.append(outerRestaurant.name)
        }
    }
    
}

var restaurantsForRoulette: RestaurantsForRoulette = RestaurantsForRoulette()

