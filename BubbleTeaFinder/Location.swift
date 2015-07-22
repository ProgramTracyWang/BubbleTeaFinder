//
//  Location.swift
//  BubbleTeaFinder
//
//  Created by Tracy on 15/7/21.
//  Copyright (c) 2015年 Tracy. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {

    @NSManaged var address: String?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var distance: NSNumber?
    @NSManaged var state: String?
    @NSManaged var zipcode: String?
    @NSManaged var venue: Venue

}
