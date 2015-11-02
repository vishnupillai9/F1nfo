//
//  ScheduleViewController.swift
//  F1nfo
//
//  Created by Vishnu on 15/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit
import CoreData

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var didFinishLoading = false
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
        }
        
        if fetchedResultsController.fetchedObjects!.isEmpty {
            getSchedule()
        }
    }
    
    // MARK: - Core Data Convenience
    
    lazy var sharedContext = {
        CoreDataStackManager.sharedInstance().managedObjectContext!
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Schedule")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "round", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] 
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "ScheduleCell"
        let raceSchedule = fetchedResultsController.objectAtIndexPath(indexPath) as! Schedule
        
        let cell  = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! ScheduleTableViewCell
        configureCell(cell, withSchedule: raceSchedule)
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
            default:
                return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! ScheduleTableViewCell
            let schedule = controller.objectAtIndexPath(indexPath!) as! Schedule
            configureCell(cell, withSchedule: schedule)
        default: return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    // MARK: - Configure Cell
    
    func configureCell(cell: ScheduleTableViewCell, withSchedule schedule: Schedule) {
        cell.tintColor = Client.Colors.CustomGray
        
        let parts = schedule.dateString.componentsSeparatedByString("-") as NSArray
        let day = (parts.objectAtIndex(2) as! NSString).integerValue
        let month = formatMonthAsString(parts.objectAtIndex(1) as! String)
        
        cell.day.text = "\(day)"
        
        if month == "September" {
            cell.month.text = "Sept"
        } else {
            cell.month.text = (month as NSString).substringWithRange(NSRange(location: 0, length: 3))
        }
        
        cell.flag.image = UIImage(named: schedule.country)
        cell.name.text = schedule.raceName
        cell.detail.text = "\(schedule.locality), \(schedule.country)"
        
        let raceDate = NSDate(dateString: schedule.dateString)
        let todaysDate = NSDate()
        
        if todaysDate.compare(raceDate) == NSComparisonResult.OrderedDescending {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        if didFinishLoading {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Helpers
    
    func getSchedule() {
        activityIndicator.startAnimating()
        
        Client.sharedInstance().getScheduleData { (success, scheduleData, errorString) -> Void in
            if success {
                let races = scheduleData!
                for race in races {
                    _ = Schedule(dictionary: race, context: self.sharedContext)
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.tableView.reloadData()
                    self.didFinishLoading = true
                    
                    CoreDataStackManager.sharedInstance().saveContext()
                }
            } else {
                self.activityIndicator.stopAnimating()
                
                //Alert view to inform user of error: failed to get data
                let alert = UIAlertController(title: "Could not complete request", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func formatMonthAsString(number: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM"
        let date = dateFormatter.dateFromString(number)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.stringFromDate(date!)
    }
    
}
