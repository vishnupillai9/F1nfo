//
//  Driver.swift
//  F1nfo
//
//  Created by Vishnu on 13/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

class Driver {
    
    struct Keys {
        static let Id = "driverId"
        static let FirstName = "givenName"
        static let LastName = "familyName"
        static let Nationality = "nationality"
        static let Url = "url"
    }
    
    var id: String
    var firstName: String
    var lastName: String
    var nationality: String
    var urlString: String
    
    init(dictionary: [String: AnyObject]) {
        id = dictionary[Keys.Id] as! String
        firstName = dictionary[Keys.FirstName] as! String
        lastName = dictionary[Keys.LastName] as! String
        nationality = dictionary[Keys.Nationality] as! String
        urlString = dictionary[Keys.Url] as! String
    }
    
}
