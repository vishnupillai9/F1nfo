//
//  FavoriteDriver.swift
//  F1nfo
//
//  Created by Vishnu on 05/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import CoreData

@objc(FavoriteDriver)

class FavoriteDriver: NSManagedObject {
    
    struct Keys {
        static let Id = "driverId"
        static let FirstName = "givenName"
        static let LastName = "familyName"
        static let Nationality = "nationality"
        static let Url = "url"
    }
    
    @NSManaged var id: String
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var nationality: String
    @NSManaged var urlString: String
    @NSManaged var results: [DriverResult]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        // Core Data
        let entity = NSEntityDescription.entityForName("FavoriteDriver", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        id = dictionary[Keys.Id] as! String
        firstName = dictionary[Keys.FirstName] as! String
        lastName = dictionary[Keys.LastName] as! String
        nationality = dictionary[Keys.Nationality] as! String
        urlString = dictionary[Keys.Url] as! String
    }
    
    var url: NSURL? {
        get {
            return NSURL(string: urlString)
        }
    }
    
}
