//
//  ConstructorStanding.swift
//  F1nfo
//
//  Created by Vishnu on 14/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

class ConstructorStanding {
    
    struct Keys {
        static let Constructor = "constructor"
        static let Position = "position"
        static let Points = "points"
    }
    
    var constructor: Constructor
    var position: Int
    var points: Int
    
    init(dictionary: [String: AnyObject]) {
        let constructorInfo = dictionary[Keys.Constructor] as! [String: AnyObject]
        constructor = Constructor(dictionary: constructorInfo)

        position = (dictionary[Keys.Position] as! NSString).integerValue
        points = (dictionary[Keys.Points] as! NSString).integerValue
    }
    
}