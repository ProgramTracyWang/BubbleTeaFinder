//
//  Stats.swift
//  BubbleTeaFinder
//
//  Created by Tracy on 15/7/21.
//  Copyright (c) 2015年 Tracy. All rights reserved.
//

import Foundation
import CoreData

class Stats: NSManagedObject {

    @NSManaged var checkinsCount: NSNumber?
    @NSManaged var tipCount: NSNumber?
    @NSManaged var usersCount: NSNumber?
    @NSManaged var venue: Venue

}
