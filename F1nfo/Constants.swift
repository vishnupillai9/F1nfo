//
//  Constants.swift
//  F1nfo
//
//  Created by Vishnu on 05/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit

extension Client {
   
    struct Constants {
        static let F1Url = "http://ergast.com/api/f1/"
        static let Year = "current"
        static let BaseUrl = F1Url + Year
        static let Format = ".json"
    }
    
    struct Methods {
        static let Drivers = "/drivers"
        static let Results = "/results"
        static let DriverStandings = "/driverStandings"
        static let ConstructorStandings = "/constructorStandings"
    }
    
    struct JSONResponseKeys {
        static let Circuit = "Circuit"
        static let CircuitId = "circuitId"
        static let CircuitName = "circuitName"
        static let Constructor = "Constructor"
        static let Constructors = "Constructors"
        static let ConstructorStandings = "ConstructorStandings"
        static let Country = "country"
        static let Date = "date"
        static let Driver = "Driver"
        static let Drivers = "Drivers"
        static let DriverStandings = "DriverStandings"
        static let DriverTable = "DriverTable"
        static let Locality = "locality"
        static let Location = "Location"
        static let MRData = "MRData"
        static let Points = "points"
        static let Position = "position"
        static let RaceName = "raceName"
        static let Races = "Races"
        static let RaceTable = "RaceTable"
        static let Results = "Results"
        static let Round = "round"
        static let StandingsLists = "StandingsLists"
        static let StandingsTable = "StandingsTable"
        static let Url = "url"
    }

    struct Helpers {
        static let Countries =  [
            "American": "USA",
            "Australian": "Australia",
            "Brazilian": "Brazil",
            "British": "UK",
            "Danish": "Denmark",
            "Dutch": "Netherlands",
            "Finnish": "Finland",
            "French": "France",
            "German": "Germany",
            "Japanese": "Japan",
            "Mexican": "Mexico",
            "Russian": "Russia",
            "Spanish": "Spain",
            "Swedish": "Sweden",
            "Venezuelan": "Venezuela"
        ]
    }
    
    struct Colors {
        static let CustomGray = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        static let CustomGoldOpaque = UIColor(red: 0.8, green: 0.6, blue: 0, alpha: 1)
        static let CustomGoldTransparent = UIColor(red: 0.8, green: 0.6, blue: 0, alpha: 0.25)
    }
    
}