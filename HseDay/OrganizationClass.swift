//
//  OrganizationClass.swift
//  HseDay
//
//  Created by Никита Римский on 20.08.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import Foundation
import CoreData

class Organization: NSManagedObject {
    
    @NSManaged var logo: NSData?
    @NSManaged var name: String?
    @NSManaged var pageImage: NSData?
    @NSManaged var pageInfo: String?
    @NSManaged var webPage: String?
    
}
