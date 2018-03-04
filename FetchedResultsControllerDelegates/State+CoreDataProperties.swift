//
//  State+CoreDataProperties.swift
//  FetchedResultsControllerDelegates
//
//  Created by Mazharul Huq on 3/2/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//
//

import Foundation
import CoreData


extension State {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<State> {
        return NSFetchRequest<State>(entityName: "State")
    }

    @NSManaged public var firstLetter: String?
    @NSManaged public var flag: String?
    @NSManaged public var name: String?
    @NSManaged public var visitCount: Int16

}
