//
//  Currency+CoreDataProperties.swift
//  ConvertFree
//
//  Created by RaghavendraX Gutta on 24/11/15.
//  Copyright © 2015 Intel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Currency {

    @NSManaged var code: String?
    @NSManaged var value: NSNumber?
    @NSManaged var name: String?

}
