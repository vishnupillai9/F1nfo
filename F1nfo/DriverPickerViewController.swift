//
//  DriverPickerViewController.swift
//  F1nfo
//
//  Created by Vishnu on 05/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit
import CoreData

protocol DriverPickerViewControllerDelegate {
    func driverPicker(driverPicker: DriverPickerViewController, didPickDriver driver: FavoriteDriver?)
}

class DriverPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var drivers = [FavoriteDriver]()
    var filteredDrivers = [FavoriteDriver]()
    var resultSearchController = UISearchController()
    var didFinishLoading: Bool = false
    var searchTask: NSURLSessionDataTask?
    var delegate: DriverPickerViewControllerDelegate?
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Client.Colors.CustomGray
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.backgroundColor = Client.Colors.CustomGray
            controller.searchBar.tintColor = UIColor.whiteColor()
            
            let textFieldInsideSearchBar = controller.searchBar.valueForKey("searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        getDrivers()
    }
    
    // MARK: - Core Data Convenience
    
    lazy var sharedContext: NSManagedObjectContext = {
        CoreDataStackManager.sharedInstance().managedObjectContext!
    }()
    
    lazy var scratchContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext()
        context.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        return context
    }()
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (resultSearchController.active) {
            return filteredDrivers.count
        }
        else {
            return drivers.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell")!
        var driver: FavoriteDriver
        
        if didFinishLoading {
            activityIndicator.stopAnimating()
        }
        
        if resultSearchController.active {
            driver = filteredDrivers[indexPath.row]
        } else {
            driver = drivers[indexPath.row]
        }
        
        cell.textLabel!.text = driver.firstName + " " + driver.lastName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var driver: FavoriteDriver
        
        if resultSearchController.active {
            driver = filteredDrivers[indexPath.row]
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            driver = drivers[indexPath.row]
        }
        
        delegate?.driverPicker(self, didPickDriver: driver)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func getDrivers() {
        activityIndicator.startAnimating()
        
        Client.sharedInstance().getDriversData { (success, driversData, errorString) -> Void in
            if success {
                let drivers = driversData!
                for driver in drivers {
                    let driverToBeAdded = FavoriteDriver(dictionary: driver, context: self.scratchContext)
                    self.drivers.append(driverToBeAdded)
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.tableView.reloadData()
                    self.didFinishLoading = true
                }
            } else {
                self.activityIndicator.stopAnimating()
                
                // Alert view to inform user of error: failed to get data
                let alert = UIAlertController(title: "Could not complete request", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredDrivers.removeAll(keepCapacity: false)
        
        filteredDrivers = drivers.filter({ (driver: FavoriteDriver) -> Bool in
            var stringMatch: Range<String.Index>?
            stringMatch = driver.firstName.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
            if stringMatch == nil {
                stringMatch = driver.lastName.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
            }
            return (stringMatch != nil)
        })
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
