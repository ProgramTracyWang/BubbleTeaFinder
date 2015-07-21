//
//  Loaction.swift
//  BubbleTeaFinder
//
//  Created by Tracy on 15/7/20.
//  Copyright (c) 2015年 Tracy. All rights reserved.
//

import Foundation
import CoreData

class Loaction: NSManagedObject {

    @NSManaged var address: String
    @NSManaged var city: String
    @NSManaged var country: String
    @NSManaged var distance: NSNumber
    @NSManaged var state: String
    @NSManaged var zipcode: String
    @NSManaged var venue: Venue

}
