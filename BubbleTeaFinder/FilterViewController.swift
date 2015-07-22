//
//  FilterViewController.swift
//  BubbleTeaFinder
//
//  Created by Tracy on 15/7/20.
//  Copyright (c) 2015年 Tracy. All rights reserved.
//

import UIKit
import CoreData

protocol FilterViewControllerDelegate: class {
    func filterViewController(filter: FilterViewController, didSelectPredicate prediacate:NSPredicate?, sortDescription: NSSortDescriptor?)
}

class FilterViewController: UITableViewController {
    var coreData: CoreDataStack!
    
    weak var delegate:FilterViewControllerDelegate?
    var selectedSortDescription: NSSortDescriptor?
    var selectedPredicate: NSPredicate?
    
    @IBOutlet weak var firstPriceCategoryLabel: UILabel!
    @IBOutlet weak var secondPriceCategoryLabel: UILabel!
    @IBOutlet weak var thirdPriceCategoryLabel: UILabel!
    @IBOutlet weak var numDealsLabel: UILabel!
    
    //Price section
    @IBOutlet weak var cheapVenueCell: UITableViewCell!
    @IBOutlet weak var moderateVenueCell: UITableViewCell!
    @IBOutlet weak var expensiveVenueCell: UITableViewCell!
    
    //Most popular section
    @IBOutlet weak var offeringDealCell: UITableViewCell!
    @IBOutlet weak var walkingDistanceCell: UITableViewCell!
    @IBOutlet weak var userTipsCell: UITableViewCell!
    
    //Sort section
    @IBOutlet weak var nameAZSortCell: UITableViewCell!
    @IBOutlet weak var nameZASortCell: UITableViewCell!
    @IBOutlet weak var distanceSortCell: UITableViewCell!
    @IBOutlet weak var priceSortCell: UITableViewCell!
    
    
    //MARK - UITableViewDelegate methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        switch cell {
            //price section
        case cheapVenueCell:
            selectedPredicate = cheapVenuePredicate
        case moderateVenueCell:
            selectedPredicate = moderateVenuePredicate
        case expensiveVenueCell:
            selectedPredicate = expensiveVenuePredicate
            //most popular section
        case offeringDealCell:
            selectedPredicate = offeringDealPredication
        case walkingDistanceCell:
            selectedPredicate = walkingDealPredication
        case userTipsCell:
            selectedPredicate = hasUserTipsDealPredication
        //sort by section
        case nameAZSortCell:
            selectedSortDescription = nameSortDescriptor
        case nameZASortCell:
            selectedSortDescription = nameSortDescriptor.reversedSortDescriptor as? NSSortDescriptor
        case priceSortCell:
            selectedSortDescription = priceSortDescription
        case distanceSortCell:
            selectedSortDescription = distanceSortDescriptor
            
        default:
            println("default case")
        }
        
        cell.accessoryType = .Checkmark
        
    }
    
    // MARK - UIButton target action
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        
        delegate?.filterViewController(self, didSelectPredicate: selectedPredicate, sortDescription: selectedSortDescription)
        
        
        dismissViewControllerAnimated(true, completion:nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        populateCheapVenueCountLabel()
        populateModerateVenueCountLabel()
        populateExpensiveVenueCountLabel()
        
        populateDealsCountLabel()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Price
    lazy var cheapVenuePredicate: NSPredicate = {
        var predicate = NSPredicate(format: "priceInfo.priceCategory == %@", "$")
        return predicate
    }()
    
    lazy var moderateVenuePredicate: NSPredicate = {
        var predicate = NSPredicate(format: "priceInfo.priceCategory == %@", "$$")
        return predicate
    }()
    
    lazy var expensiveVenuePredicate: NSPredicate = {
        var predicate = NSPredicate(format: "priceInfo.priceCategory == %@", "$$$")
        return predicate
        }()

    func populateCheapVenueCountLabel() {
        //$ fetch request
        
        let fetchRequest = NSFetchRequest(entityName: "Venue")
        fetchRequest.resultType = .CountResultType
        fetchRequest.predicate = cheapVenuePredicate
        
        var error: NSError?
        let result = coreData.context.executeFetchRequest(fetchRequest, error: &error) as? [NSNumber]
        
        if let countArray = result {
            let count = countArray[0].integerValue
            
            firstPriceCategoryLabel.text = "\(count) bubble tea places"
        }else {
            println("Could not fetch \(error), \(error?.userInfo)")
        }
    }
    func populateModerateVenueCountLabel() {
        //$ fetch request
        
        let fetchRequest = NSFetchRequest(entityName: "Venue")
        fetchRequest.resultType = .CountResultType
        fetchRequest.predicate = moderateVenuePredicate
        
        var error: NSError?
        let result = coreData.context.executeFetchRequest(fetchRequest, error: &error) as? [NSNumber]
        
        if let countArray = result {
            let count = countArray[0].integerValue
            
            secondPriceCategoryLabel.text = "\(count) bubble tea places"
        }else {
            println("Could not fetch \(error), \(error?.userInfo)")
        }
    }
    func populateExpensiveVenueCountLabel() {
        //$ fetch request
        
        let fetchRequest = NSFetchRequest(entityName: "Venue")
        fetchRequest.resultType = .CountResultType
        fetchRequest.predicate = expensiveVenuePredicate
        
        var error: NSError?
        let result = coreData.context.executeFetchRequest(fetchRequest, error: &error) as? [NSNumber]
        
        if let countArray = result {
            let count = countArray[0].integerValue
            
            thirdPriceCategoryLabel.text = "\(count) bubble tea places"
        }else {
            println("Could not fetch \(error), \(error?.userInfo)")
        }
    }
    func populateDealsCountLabel() {
        //1 
        let fetchRequest = NSFetchRequest(entityName: "Venue")
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        
        //2
        let sumExpressionDesc = NSExpressionDescription()
        sumExpressionDesc.name = "sumDeals"
        
        //3 
        sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "specialCount")])
        
        sumExpressionDesc.expressionResultType = NSAttributeType.Integer32AttributeType
        
        //4 
        fetchRequest.propertiesToFetch = [sumExpressionDesc]
        
        //5 
        var error: NSError?
        let result = coreData.context.executeFetchRequest(fetchRequest, error: &error) as? [NSDictionary]
        if let resultArray = result {
            let resultDict = resultArray[0]
            let numDeals: AnyObject! = resultDict["sumDeals"]
            numDealsLabel.text = "\(numDeals) total deals"
        } else {
            println("Could not fetch\(error),\(error?.userInfo)")
        }
        
    }
    //MARK:Popular
    
    lazy var offeringDealPredication: NSPredicate = {
        var pr = NSPredicate(format: "specialCount > 0")
        return pr
    }()
    lazy var walkingDealPredication: NSPredicate = {
        var pr = NSPredicate(format: "location.distance < 500")
        return pr
        }()
    lazy var hasUserTipsDealPredication: NSPredicate = {
        var pr = NSPredicate(format: "stats.tipCount > 0")
        return pr
        }()
    
    //MARK: sort
    
    lazy var nameSortDescriptor: NSSortDescriptor = {
        var sd = NSSortDescriptor(key: "name", ascending: true, selector: "localizedStandardCompare:")
        return sd
    
    }()
    lazy var distanceSortDescriptor: NSSortDescriptor = {
    
        var sd = NSSortDescriptor(key: "location.distance", ascending: true)
        return sd
    }()
    lazy var priceSortDescription: NSSortDescriptor = {
        var sd = NSSortDescriptor(key: "priceInfo.priceCategory", ascending: true)
        return sd
    }()
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
