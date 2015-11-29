//
//  StandingsViewController.swift
//  F1nfo
//
//  Created by Vishnu on 13/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit

class StandingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var didFinishLoading: Bool = false
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        
        getDriverStandings()
    }

    // MARK: - Table View

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedController.selectedSegmentIndex {
            case 0: return appDelegate.driverStandings.count
            case 1: return appDelegate.constructorStandings.count
            default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StandingsCell") as! StandingsTableViewCell
        
        switch segmentedController.selectedSegmentIndex {
            case 0:
                let driverStanding = appDelegate.driverStandings[indexPath.row]
                configureCellForDrivers(cell, withStanding: driverStanding)
            case 1:
                let constructorStanding = appDelegate.constructorStandings[indexPath.row]
                configureCellForConstructors(cell, withStanding: constructorStanding)
            default: break
        }
        
        let position = (cell.position.text! as NSString).integerValue
        
        if position == 1 {
            cell.backgroundColor = Client.Colors.CustomGoldTransparent
            cell.positionView.backgroundColor = Client.Colors.CustomGoldOpaque
            cell.pointsView.backgroundColor = Client.Colors.CustomGoldOpaque
        } else {
            cell.backgroundColor = UIColor.whiteColor()
            cell.positionView.backgroundColor = Client.Colors.CustomGray
            cell.pointsView.backgroundColor = Client.Colors.CustomGray
        }
        
        if didFinishLoading {
            activityIndicator.stopAnimating()
        }
        
        return cell
    }
    
    // MARK: - Configure Cell
    
    func configureCellForDrivers(cell: StandingsTableViewCell, withStanding driverStanding: DriverStanding) {
        cell.position.text = "\(driverStanding.position)"
        cell.flag.image = UIImage(named: Client.Helpers.Countries[driverStanding.driver.nationality]!)
        cell.name.text = driverStanding.driver.firstName + " " + driverStanding.driver.lastName
        cell.points.text = "\(driverStanding.points)"
    }
    
    func configureCellForConstructors(cell: StandingsTableViewCell, withStanding constructorStanding: ConstructorStanding) {
        cell.position.text = "\(constructorStanding.position)"
        cell.flag.image = nil
        cell.name.text = constructorStanding.constructor.name
        cell.points.text = "\(constructorStanding.points)"
    }
    
    // MARK: - Helpers
    
    func getDriverStandings() {
        activityIndicator.startAnimating()
        
        Client.sharedInstance().getDriverStandingsData { (success, driverStandingsData, errorString) -> Void in
            if success {
                let driverStandings = driverStandingsData!
                for driver in driverStandings {
                    let standingToBeAdded = DriverStanding(dictionary: driver)
                    self.appDelegate.driverStandings.append(standingToBeAdded)
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.tableView.reloadData()
                    self.didFinishLoading = true
                }
            } else {
                self.alertViewForError(errorString)
            }
        }
    }
    
    func getConstructorStandings() {
        activityIndicator.startAnimating()
        
        Client.sharedInstance().getConstructorStandingsData { (success, constructorStandingsData, errorString) -> Void in
            if success {
                let constructorStandings = constructorStandingsData!
                for constructor in constructorStandings {
                    let standingToBeAdded = ConstructorStanding(dictionary: constructor)
                    self.appDelegate.constructorStandings.append(standingToBeAdded)
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.tableView.reloadData()
                    self.didFinishLoading = true
                }
            } else {
                self.alertViewForError(errorString)
            }
        }
    }
    
    func alertViewForError(errorString: String?) {
        activityIndicator.stopAnimating()
        
        // Alert view to inform user of error: failed to get data
        let alert = UIAlertController(title: "Could not complete request", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(dismissAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func switchStandings(sender: UISegmentedControl) {
        switch segmentedController.selectedSegmentIndex {
            case 0:
                if appDelegate.driverStandings.isEmpty && !activityIndicator.isAnimating() {
                    getDriverStandings()
                }
                tableView.reloadData()
            case 1:
                if appDelegate.constructorStandings.isEmpty && !activityIndicator.isAnimating() {
                    getConstructorStandings()
                }
                tableView.reloadData()
            default: break
        }
    }
    
    
}
