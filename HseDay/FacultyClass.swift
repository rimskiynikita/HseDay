//
//  FacultyClass.swift
//  HseDay
//
//  Created by Никита Римский on 03.08.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import Foundation
import CoreData

class Faculty: NSManagedObject {
    
    @NSManaged var name: String?
    @NSManaged var pageImage: NSData?
    @NSManaged var pageInfo: String?
    @NSManaged var directions: String?
    @NSManaged var webPage: String?
    
}
