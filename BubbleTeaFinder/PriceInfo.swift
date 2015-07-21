//
//  PriceInfo.swift
//  BubbleTeaFinder
//
//  Created by Tracy on 15/7/20.
//  Copyright (c) 2015年 Tracy. All rights reserved.
//

import Foundation
import CoreData

class PriceInfo: NSManagedObject {

    @NSManaged var priceCategory: String
    @NSManaged var venue: Venue

}
