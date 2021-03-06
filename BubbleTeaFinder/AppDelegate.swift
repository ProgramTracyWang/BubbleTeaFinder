//
//  AppDelegate.swift
//  BubbleTeaFinder
//
//  Created by Tracy on 15/7/20.
//  Copyright (c) 2015年 Tracy. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var  coreDataStack = CoreDataStack()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        importJSONSeedDataIfNeeded()
        
        let navController = window!.rootViewController as! UINavigationController
        let viewController = navController.topViewController as! ViewController
        viewController.coreDataStack = coreDataStack
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataStack.saveContext()
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.ZJUT.BubbleTeaFinder" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("BubbleTeaFinder", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("BubbleTeaFinder.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    //MARK: JSON
    func importJSONSeedDataIfNeeded() {
        
        let fetchRequest = NSFetchRequest(entityName: "Venue")
        var error: NSError? = nil
        
        let results =
        coreDataStack.context.countForFetchRequest(fetchRequest,
            error: &error)
        
        if (results == 0) {
            
            var fetchError: NSError? = nil
            
            let results =
            coreDataStack.context.executeFetchRequest(fetchRequest,
                error: &fetchError) as! [Venue]
            
            for object in results {
                let team = object as Venue
                coreDataStack.context.deleteObject(team)
            }
            
            coreDataStack.saveContext()
            importJSONSeedData()
        }
    }
    
    func importJSONSeedData() {
        let jsonURL = NSBundle.mainBundle().URLForResource("seed", withExtension: "json")
        let jsonData = NSData(contentsOfURL: jsonURL!)
        
        var error: NSError? = nil
        let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error) as! NSDictionary
        
        let venueEntity = NSEntityDescription.entityForName("Venue", inManagedObjectContext: coreDataStack.context)
        
        let locationEntity = NSEntityDescription.entityForName("Location", inManagedObjectContext: coreDataStack.context)
        
        let categoryEntity = NSEntityDescription.entityForName("Category", inManagedObjectContext: coreDataStack.context)
        
        let priceEntity = NSEntityDescription.entityForName("PriceInfo", inManagedObjectContext: coreDataStack.context)
        
        let statsEntity = NSEntityDescription.entityForName("Stats", inManagedObjectContext: coreDataStack.context)
        
        let jsonArray = jsonDict.valueForKeyPath("response.venues") as! NSArray
        
        for jsonDictionary in jsonArray {
            
            let venueName = jsonDictionary["name"] as? String
            let venuePhone = jsonDictionary.valueForKeyPath("contact.phone") as? String
            let specialCount = jsonDictionary.valueForKeyPath("specials.count") as? NSNumber
            
            let locationDict = jsonDictionary["location"] as! NSDictionary
            let priceDict = jsonDictionary["price"]as! NSDictionary
            let statsDict = jsonDictionary["stats"]as! NSDictionary
            
            let location = Location(entity: locationEntity!, insertIntoManagedObjectContext: coreDataStack.context)
            location.address = locationDict["address"] as? String
            location.city = locationDict["city"] as? String
            location.state = locationDict["state"] as? String
            location.zipcode = locationDict["postalCode"] as? String
            location.distance = locationDict["distance"] as? NSNumber
            
            let category = Category(entity: categoryEntity!, insertIntoManagedObjectContext: coreDataStack.context)
            
            let priceInfo = PriceInfo(entity: priceEntity!, insertIntoManagedObjectContext: coreDataStack.context)
            priceInfo.priceCategory = priceDict["currency"] as? String
            
            let stats = Stats(entity: statsEntity!, insertIntoManagedObjectContext: coreDataStack.context)
            stats.checkinsCount = statsDict["checkinsCount"] as? NSNumber
            stats.usersCount = statsDict["userCount"] as? NSNumber
            stats.tipCount = statsDict["tipCount"] as? NSNumber
            
            let venue = Venue(entity: venueEntity!, insertIntoManagedObjectContext: coreDataStack.context)
            venue.name = venueName
            venue.phone = venuePhone
            venue.specialCount = specialCount
            venue.location = location
            venue.category = category
            venue.priceInfo = priceInfo
            venue.stats = stats
        }
        
        coreDataStack.saveContext()
    }

}

