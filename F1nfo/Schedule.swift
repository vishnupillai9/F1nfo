//
//  Schedule.swift
//  F1nfo
//
//  Created by Vishnu on 15/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import CoreData

@objc(Schedule)

class Schedule: NSManagedObject {
    
    struct Keys {
        static let Round = "round"
        static let Date = "date"
        static let RaceName = "raceName"
        static let CircuitId = "circuitId"
        static let CircuitName = "circuitName"
        static let Country = "country"
        static let Locality = "locality"
    }
    
    @NSManaged var round: Int32
    @NSManaged var dateString: String
    @NSManaged var raceName: String
    @NSManaged var circuitId: String
    @NSManaged var circuitName: String
    @NSManaged var country: String
    @NSManaged var locality: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        // Core Data
        let entity = NSEntityDescription.entityForName("Schedule", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        round = Int32.init(dictionary[Keys.Round] as! Int)
        dateString = dictionary[Keys.Date] as! String
        raceName = dictionary[Keys.RaceName] as! String
        circuitId = dictionary[Keys.CircuitId] as! String
        circuitName = dictionary[Keys.CircuitName] as! String
        country = dictionary[Keys.Country] as! String
        locality = dictionary[Keys.Locality] as! String
    }
    
}