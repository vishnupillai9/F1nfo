//
//  DriverResultsViewController.swift
//  F1nfo
//
//  Created by Vishnu on 06/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit
import CoreData

class DriverResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var driver: FavoriteDriver!
    var didFinishLoading: Bool = false
    
    // MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = driver!.firstName + " " + driver!.lastName
        
        tableView.allowsSelection = false
        
        if driver.results.isEmpty {
            getResults()
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
            print("Error in performing fetch")
        }
        fetchedResultsController.delegate = self
    }
    
    // MARK: - Core Data Convenience
    
    lazy var sharedContext = {
        CoreDataStackManager.sharedInstance().managedObjectContext!
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "DriverResult")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "raceRound", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "driver == %@", self.driver)
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] 
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Results"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "ResultCell"
        let result = fetchedResultsController.objectAtIndexPath(indexPath) as! DriverResult
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! ResultTableViewCell
        configureCell(cell, withResult: result)
        return cell
    }
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! ResultTableViewCell
            let result = controller.objectAtIndexPath(indexPath!) as! DriverResult
            configureCell(cell, withResult: result)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    // MARK: - Preview Actions
    
    @available(iOS 9.0, *)
    override func previewActionItems() -> [UIPreviewActionItem] {
        let deleteAction = UIPreviewAction(title: "Delete", style: .Destructive) { (action, controller) -> Void in
            self.sharedContext.deleteObject(self.driver)
            CoreDataStackManager.sharedInstance().saveContext()
        }
        
        return [deleteAction]
    }
    
    // MARK: - Configure Cell
    
    func configureCell(cell: ResultTableViewCell, withResult result: DriverResult) {
        cell.flag.image = UIImage(named: result.raceCountry)
        cell.race.text = result.raceName
        cell.status.text = result.status
        cell.position.text = result.position
        cell.time.text = result.time
        cell.points.text = "Pts: \(result.points)"
        
        let position = (result.position as NSString).integerValue
        if position == 1 {
            cell.status.text = "Winner"
            cell.statusView.backgroundColor = Client.Colors.CustomGoldOpaque
            cell.positionView.backgroundColor = Client.Colors.CustomGoldOpaque
            cell.backgroundColor = Client.Colors.CustomGoldTransparent
        } else {
            cell.statusView.backgroundColor = Client.Colors.CustomGray
            cell.positionView.backgroundColor = Client.Colors.CustomGray
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        if didFinishLoading {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Helpers
    
    func getResults() {
        activityIndicator.startAnimating()
        
        let driverId = driver!.id
        Client.sharedInstance().getResultsData(driverId) { (success, resultsData, errorString) -> Void in
            if success {
                let results = resultsData!
                for res in results {
                    let result = DriverResult(dictionary: res, context: self.sharedContext)
                    result.driver = self.driver
                }
                // Update UI
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
    
}
