//
//  DriverResult.swift
//  F1nfo
//
//  Created by Vishnu on 07/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import CoreData

@objc(DriverResult)

class DriverResult: NSManagedObject {
    
    struct Keys {
        static let Round = "round"
        static let RaceName = "name"
        static let Country = "country"
        static let ResultDict = "resultDictionary"
        static let Position = "positionText"
        static let Status = "status"
        static let TimeDict = "Time"
        static let Time = "time"
        static let Points = "points"
    }
    
    @NSManaged var raceRound: Int32
    @NSManaged var raceName: String
    @NSManaged var raceCountry: String
    @NSManaged var position: String
    @NSManaged var status: String
    @NSManaged var time: String?
    @NSManaged var points: Int32
    @NSManaged var driver: FavoriteDriver?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        // Core Data
        let entity = NSEntityDescription.entityForName("DriverResult", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary #1
        raceRound = Int32.init(dictionary[Keys.Round] as! Int)
        raceName = dictionary[Keys.RaceName] as! String
        raceCountry = dictionary[Keys.Country] as! String
        
        // Dictionary #2
        let resultDictionary = dictionary[Keys.ResultDict] as! [String: AnyObject]
        
        position = resultDictionary[Keys.Position] as! String
        status = resultDictionary[Keys.Status] as! String
        if status == "Finished" {
            if let timeDictionary = resultDictionary[Keys.TimeDict] as? [String: String] {
                time = timeDictionary[Keys.Time]!
            } else {
                time = "N/A"
            }
        }
        points = Int32.init((resultDictionary[Keys.Points] as! NSString).integerValue)
    }
    
}