//
//  DriverStanding.swift
//  F1nfo
//
//  Created by Vishnu on 13/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

class DriverStanding {
    
    struct Keys {
        static let Driver = "driver"
        static let Constructor = "constructor"
        static let Position = "position"
        static let Points = "points"
    }
    
    var driver: Driver
    var constructor: Constructor?
    var position: Int
    var points: Int
    
    init(dictionary: [String: AnyObject?]) {
        let driverInfo = dictionary[Keys.Driver] as! [String: AnyObject]
        driver = Driver(dictionary: driverInfo)
        
        if let constructorInfo = dictionary[Keys.Constructor] as? [String: AnyObject] {
            constructor = Constructor(dictionary: constructorInfo)
        }
        
        position = (dictionary[Keys.Position] as! NSString).integerValue
        points = (dictionary[Keys.Points] as! NSString).integerValue
    }
    
}