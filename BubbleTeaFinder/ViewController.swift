//
//  ViewController.swift
//  BubbleTeaFinder
//
//  Created by Tracy on 15/7/20.
//  Copyright (c) 2015年 Tracy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController,FilterViewControllerDelegate {
    
    
    var coreDataStack: CoreDataStack!
    
    //add below var coreData: CoreData
    var fetchRequest: NSFetchRequest!
    var asyncFetchRequest: NSAsynchronousFetchRequest!
    var venues: [Venue]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //batch update
        let batchUpdate = NSBatchUpdateRequest(entityName: "Venue")
        batchUpdate.propertiesToUpdate = ["favorite" : NSNumber(bool: true)]
        batchUpdate.affectedStores = coreDataStack.psc.persistentStores
        batchUpdate.resultType = NSBatchUpdateRequestResultType.UpdatedObjectsCountResultType
        
        var batchError: NSError?
        let batchResult = coreDataStack.context.executeRequest(batchUpdate, error: &batchError) as? NSBatchUpdateResult
        
        if let result = batchResult {
            println("record update \(result.result!)")
        } else{
            println("could not update\(batchError),\(batchError?.userInfo)")
        }
        
       // fetchRequest = coreDataStack.model.fetchRequestTemplateForName("FetchRequest")
        
        fetchRequest = NSFetchRequest(entityName: "Venue")
        
        asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest, completionBlock: { (result: NSAsynchronousFetchResult!) -> Void in
            self.venues = result.finalResult as! [Venue]
            self.tableView.reloadData()
        })
        
        var error:NSError?
        let result = coreDataStack.context.executeRequest(asyncFetchRequest, error: &error)
        
        if let persistentStoreResults = result {
            // return immediately ,cancel here if you want
        } else {
            println("could not fetch \(error),\(error?.userInfo)")
        }
        
        fetchAndReload()
    }

    //MARK: table source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VenueCell") as! UITableViewCell
      
        let venue = venues[indexPath.row]
        cell.textLabel!.text = venue.name
        cell.detailTextLabel!.text = venue.priceInfo.priceCategory
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toFilterViewController" {
            
            let navController = segue.destinationViewController as!  UINavigationController
            let filterVC = navController.topViewController as! FilterViewController
            
            //add the line blow
            filterVC.coreData = coreDataStack
            
            filterVC.delegate = self
        }
    }
    
    //MARK - Helper method
    
    func fetchAndReload() {
        var error: NSError?
        let results = coreDataStack.context.executeFetchRequest(fetchRequest, error: &error)
        
        if let fetchedResults = results {
            venues = fetchedResults as! [Venue]
        }else {
            println("Could not fetch:\(error),\(error?.userInfo)")
        }
        tableView.reloadData()
    }
    @IBAction func unwindToVenuListViewController(segue: UIStoryboardSegue) {
        
    }
    
    //MARK: FilterViewControllerDelegate method
    
    func filterViewController(filter: FilterViewController, didSelectPredicate prediacate: NSPredicate?, sortDescription: NSSortDescriptor?) {
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        
        if let fetchPredicate = prediacate {
            fetchRequest.predicate = fetchPredicate
            
        }
        
        if let  sr = sortDescription {
            fetchRequest.sortDescriptors = [sr]
        }
        
        fetchAndReload()
    }
    
}

