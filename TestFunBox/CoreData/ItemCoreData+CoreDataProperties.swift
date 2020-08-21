//
//  ItemCoreData+CoreDataProperties.swift
//  TestFunBox
//
//  Created by Stanislav on 14.08.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemCoreData> {
        return NSFetchRequest<ItemCoreData>(entityName: "ItemCoreData")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var count: String?

}
