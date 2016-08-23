//
//  PinInformation.swift
//  HseDay
//
//  Created by Никита Римский on 09.08.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import Foundation
import CoreData

class PinInformation: NSManagedObject {
    
    @NSManaged var image: String?
    @NSManaged var xPosition: NSNumber?
    @NSManaged var yPosition: NSNumber?
    @NSManaged var annotation: String?
    @NSManaged var infoPageImage: NSData?
    @NSManaged var questPageTextOrFacOrgName: String?
    @NSManaged var questPassword: String?
    
}