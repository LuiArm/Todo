//
//  Todo+CoreDataProperties.swift
//  Todo
//
//  Created by luis armendariz on 7/24/23.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var text: String
    @NSManaged public var isDone: Bool
    @NSManaged public var timestamp: Date

}

extension Todo : Identifiable {

}
