//
//  ViewController.swift
//  BubbleTeaFinder
//
//  Created by Tracy on 15/7/20.
//  Copyright (c) 2015年 Tracy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toFilterViewController" {
            
            let navController = segue.destinationViewController as!  UINavigationController
            let filterVC = navController.topViewController as! FilterViewController
        }
    }
    @IBAction func unwindToVenuListViewController(segue: UIStoryboardSegue) {
        
    }
    
}

