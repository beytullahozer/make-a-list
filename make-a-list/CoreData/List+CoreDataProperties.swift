//
//  List+CoreDataProperties.swift
//  make-a-list
//
//  Created by Beytullah Özer on 17.04.2022.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var name: String?
    @NSManaged public var created: Date?

}

extension List : Identifiable {

}
