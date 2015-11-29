//
//  FavoriteDriversViewController.swift
//  F1nfo
//
//  Created by Vishnu on 05/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class FavoriteDriversViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DriverPickerViewControllerDelegate, NSFetchedResultsControllerDelegate, UIViewControllerPreviewingDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
            print("Error in performing fetch")
        }
        fetchedResultsController.delegate = self
        
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .Available {
                registerForPreviewingWithDelegate(self, sourceView: view)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "FavoriteDriver")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: - Driver Picker Delegate
    
    func driverPicker(driverPicker: DriverPickerViewController, didPickDriver driver: FavoriteDriver?) {
        if let newDriver = driver {
            let drivers = fetchedResultsController.fetchedObjects as! [FavoriteDriver]
            for driver in drivers {
                if driver.id == newDriver.id {
                    return
                }
            }
            
            let dictionary: [String: AnyObject] = [
                FavoriteDriver.Keys.Id: newDriver.id,
                FavoriteDriver.Keys.FirstName: newDriver.firstName,
                FavoriteDriver.Keys.LastName: newDriver.lastName,
                FavoriteDriver.Keys.Nationality: newDriver.nationality,
                FavoriteDriver.Keys.Url: newDriver.urlString
            ]
            
            _ = FavoriteDriver(dictionary: dictionary, context: sharedContext)
            
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] 
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "DriverCell"
        let driver = fetchedResultsController.objectAtIndexPath(indexPath) as! FavoriteDriver
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! DriverTableViewCell
        configureCell(cell, withDriver: driver)
        return cell
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let driver = fetchedResultsController.objectAtIndexPath(indexPath) as! FavoriteDriver
        
        if #available(iOS 9.0, *) {
            presentSafariViewController(driver.url)
        } else {
            let controller = storyboard!.instantiateViewControllerWithIdentifier("DriverInfoViewController") as! DriverInfoViewController
            
            controller.url = driver.url
            navigationItem.title = driver.firstName + " " + driver.lastName
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let driver = fetchedResultsController.objectAtIndexPath(indexPath) as! FavoriteDriver
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("DriverResultsViewController") as! DriverResultsViewController
        controller.driver = driver
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
            case .Delete:
                let driver = fetchedResultsController.objectAtIndexPath(indexPath) as! FavoriteDriver
                sharedContext.deleteObject(driver)
                CoreDataStackManager.sharedInstance().saveContext()
            default:
                break
        }
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
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! DriverTableViewCell
            let driver = controller.objectAtIndexPath(indexPath!) as! FavoriteDriver
            configureCell(cell, withDriver: driver)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    // MARK: - Configure Cell
    
    func configureCell(cell: DriverTableViewCell, withDriver driver: FavoriteDriver) {
        cell.name.text = driver.firstName + " " + driver.lastName
        cell.flag.image = UIImage(named: Client.Helpers.Countries[driver.nationality]!)
        cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        cell.tintColor = Client.Colors.CustomGray
    }
    
    // MARK: - View Controller Previewing Delegate
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let cellPosition = tableView.convertPoint(location, fromView: view)
        
        guard let indexPath = tableView.indexPathForRowAtPoint(cellPosition) else { return nil }
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return nil }
        
        let driver = fetchedResultsController.objectAtIndexPath(indexPath) as! FavoriteDriver
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("DriverResultsViewController") as! DriverResultsViewController
        controller.driver = driver
        
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = view.convertRect(cell.frame, fromCoordinateSpace: tableView)
        }
        
        return controller
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
    
    // MARK: - Actions
    
    @IBAction func addDriver() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("DriverPickerViewController") as! DriverPickerViewController
        
        controller.delegate = self
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    @available(iOS 9.0, *)
    func presentSafariViewController(url: NSURL?) {
        guard let url = url else { print("Invalid URL"); return; }
        
        let svc = SFSafariViewController(URL: url)
        presentViewController(svc, animated: true, completion: nil)
    }
    
}

