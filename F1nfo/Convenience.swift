//
//  Convenience.swift
//  F1nfo
//
//  Created by Vishnu on 07/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit

extension Client {
    
    func getData(method: String, completionHandler: (success: Bool, dictionary: NSDictionary?, errorString: String?) -> Void) {
        _ = taskForGETMethod(method) { (JSONResult, error) -> Void in
            if let error = error {
                completionHandler(success: false, dictionary: nil, errorString: "\(error.localizedDescription)")
            } else {
                if let mrData = JSONResult.valueForKey(JSONResponseKeys.MRData) as? NSDictionary {
                    completionHandler(success: true, dictionary: mrData, errorString: nil)
                } else {
                    completionHandler(success: false, dictionary: nil, errorString: "\(error?.localizedDescription)")
                }
            }
        }
    }
    
    func getDriversData(completionHandler: (success: Bool, driversData: [[String: AnyObject]]?, errorString: String?) -> Void) {
        let method = Methods.Drivers
        
        getData(method) { (success, dictionary, errorString) -> Void in
            if success {
                let mrData = dictionary!
                let driverTable = mrData.valueForKey(JSONResponseKeys.DriverTable) as! NSDictionary
                if let drivers = driverTable.valueForKey(JSONResponseKeys.Drivers) as? [[String:AnyObject]] {
                    completionHandler(success: true, driversData: drivers, errorString: nil)
                } else {
                    completionHandler(success: false, driversData: nil, errorString: errorString)
                }
            } else {
                completionHandler(success: false, driversData: nil, errorString: errorString)
            }
        }
    }
    
    func getResultsData(driverId: String, completionHandler: (success: Bool, resultsData: [[String: AnyObject]]?, errorString: String?) -> Void) {
        let method = Methods.Drivers + "/\(driverId)" + Methods.Results
        
        getData(method) { (success, dictionary, errorString) -> Void in
            if success {
                let mrData = dictionary!
                let raceTable = mrData.valueForKey(JSONResponseKeys.RaceTable) as! NSDictionary
                let races = raceTable.valueForKey(JSONResponseKeys.Races) as! [[String:AnyObject]]
                
                var resultsData = [[String: AnyObject]]()
                
                for race in races {
                    let results = race[JSONResponseKeys.Results] as! [[String:AnyObject]]
                    for result in results {
                        let circuit = race[JSONResponseKeys.Circuit] as! [String:AnyObject]
                        let circuitLocation = circuit[JSONResponseKeys.Location] as! [String:AnyObject]
                        let raceCountry = circuitLocation[JSONResponseKeys.Country] as! String
                        let raceName = race[JSONResponseKeys.RaceName] as! String
                        let raceRound = (race[JSONResponseKeys.Round] as! NSString).integerValue
                        
                        let resultData: [String: AnyObject] = [
                            DriverResult.Keys.Round: raceRound,
                            DriverResult.Keys.RaceName: raceName,
                            DriverResult.Keys.Country: raceCountry,
                            DriverResult.Keys.ResultDict: result
                        ]
                        
                        resultsData.append(resultData)
                    }
                }
                completionHandler(success: true, resultsData: resultsData, errorString: nil)
            } else {
                completionHandler(success: false, resultsData: nil, errorString: errorString)
            }
        }
    }
    
    func getScheduleData(completionHandler: (success: Bool, scheduleData: [[String: AnyObject]]?, errorString: String?) -> Void) {
        let method = ""
        
        getData(method) { (success, dictionary, errorString) -> Void in
            if success {
                let mrData = dictionary!
                let raceTable = mrData.valueForKey(JSONResponseKeys.RaceTable) as! NSDictionary
                let races = raceTable.valueForKey(JSONResponseKeys.Races) as! [NSDictionary]
                
                var scheduleData = [[String: AnyObject]]()
                
                for race in races {
                    let round = (race.valueForKey(JSONResponseKeys.Round) as! NSString).integerValue
                    let date = race.valueForKey(JSONResponseKeys.Date) as! String
                    let raceName = race.valueForKey(JSONResponseKeys.RaceName) as! String
                    
                    let circuit = race.valueForKey(JSONResponseKeys.Circuit) as! NSDictionary
                    let circuitId = circuit.valueForKey(JSONResponseKeys.CircuitId) as! String
                    let circuitName = circuit.valueForKey(JSONResponseKeys.CircuitName) as! String
                    
                    let location = circuit.valueForKey(JSONResponseKeys.Location) as! [String: AnyObject]
                    let country = location[JSONResponseKeys.Country] as! String
                    let locality = location[JSONResponseKeys.Locality] as! String
                    
                    let entry: [String: AnyObject] = [
                        Schedule.Keys.Round: round,
                        Schedule.Keys.Date: date,
                        Schedule.Keys.RaceName: raceName,
                        Schedule.Keys.CircuitId: circuitId,
                        Schedule.Keys.CircuitName: circuitName,
                        Schedule.Keys.Country: country,
                        Schedule.Keys.Locality: locality
                    ]
                    
                    scheduleData.append(entry)
                }
                completionHandler(success: true, scheduleData: scheduleData, errorString: nil)
            } else {
                completionHandler(success: false, scheduleData: nil, errorString: errorString)
            }
        }
    }
    
    func getDriverStandingsData(completionHandler: (success: Bool, driverStandingsData: [[String: AnyObject?]]?, errorString: String?) -> Void) {
        let method = Methods.DriverStandings
        
        getData(method) { (success, dictionary, errorString) -> Void in
            if success {
                let mrData = dictionary!
                let standingsTable = mrData[JSONResponseKeys.StandingsTable] as! NSDictionary
                let standingsLists = standingsTable[JSONResponseKeys.StandingsLists] as! [NSDictionary]
                let standings = standingsLists.first!
                let driverStandings = standings[JSONResponseKeys.DriverStandings] as! [NSDictionary]
                
                var driverStandingsData = [[String: AnyObject?]]()
                
                for driver in driverStandings {
                    let driverInfo = driver[Client.JSONResponseKeys.Driver] as! [String: AnyObject]
                    let constructors = driver[Client.JSONResponseKeys.Constructors] as? [NSDictionary]
                    let constructorInfo = constructors?.first!
                    let position = driver[Client.JSONResponseKeys.Position] as! String
                    let points = driver[Client.JSONResponseKeys.Points] as! String
                    
                    let driverStanding: [String: AnyObject?] = [
                        DriverStanding.Keys.Driver: driverInfo,
                        DriverStanding.Keys.Constructor: constructorInfo,
                        DriverStanding.Keys.Position: position,
                        DriverStanding.Keys.Points: points
                    ]
                    
                    driverStandingsData.append(driverStanding)
                }
                completionHandler(success: true, driverStandingsData: driverStandingsData, errorString: nil)
            } else {
                completionHandler(success: false, driverStandingsData: nil, errorString: errorString)
            }
        }
    }
    
    func getConstructorStandingsData(completionHandler: (success: Bool, constructorStandingsData: [[String: AnyObject]]?, errorString: String?) -> Void) {
        let method = Methods.ConstructorStandings
        
        getData(method) { (success, dictionary, errorString) -> Void in
            if success {
                let mrData = dictionary!
                let standingsTable = mrData[JSONResponseKeys.StandingsTable] as! NSDictionary
                let standingsLists = standingsTable[JSONResponseKeys.StandingsLists] as! [NSDictionary]
                let standings = standingsLists.first!
                let constructorStandings = standings[JSONResponseKeys.ConstructorStandings] as! [NSDictionary]
                
                var constructorStandingsData = [[String: AnyObject]]()
                
                for constructor in constructorStandings {
                    let constructorInfo = constructor[JSONResponseKeys.Constructor] as! [String: AnyObject]
                    let position = constructor[JSONResponseKeys.Position] as! String
                    let points = constructor[JSONResponseKeys.Points] as! String
                    
                    let constructorStanding: [String: AnyObject] = [
                        ConstructorStanding.Keys.Constructor: constructorInfo,
                        ConstructorStanding.Keys.Position: position,
                        ConstructorStanding.Keys.Points: points
                    ]
                    
                    constructorStandingsData.append(constructorStanding)
                }
                completionHandler(success: true, constructorStandingsData: constructorStandingsData, errorString: nil)
            } else {
                completionHandler(success: false, constructorStandingsData: nil, errorString: errorString)
            }
        }
    }
    
    
    
}