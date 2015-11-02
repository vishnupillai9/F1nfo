//
//  Constructor.swift
//  F1nfo
//
//  Created by Vishnu on 05/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

class Constructor {
    
    struct Keys {
        static let Id = "constructorId"
        static let Name = "name"
        static let Nationality = "nationality"
        static let Url = "url"
    }
    
    var id: String
    var name: String
    var nationality: String
    
    init(dictionary: [String: AnyObject]) {
        id = dictionary[Keys.Id] as! String
        name = dictionary[Keys.Name] as! String
        nationality = dictionary[Keys.Nationality] as! String
    }
    
}