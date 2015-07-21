//
//  Venue.swift
//  BubbleTeaFinder
//
//  Created by Tracy on 15/7/20.
//  Copyright (c) 2015年 Tracy. All rights reserved.
//

import Foundation
import CoreData

class Venue: NSManagedObject {

    @NSManaged var favorite: NSNumber
    @NSManaged var name: String
    @NSManaged var phone: String
    @NSManaged var specialCount: NSNumber
    @NSManaged var category: Category
    @NSManaged var location: Loaction
    @NSManaged var priceInfo: PriceInfo
    @NSManaged var stats: Stats

}
