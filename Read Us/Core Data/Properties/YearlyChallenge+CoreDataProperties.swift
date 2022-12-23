//
//  YearlyChallenge+CoreDataProperties.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/18/22.
//
//

import Foundation
import CoreData


extension YearlyChallenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<YearlyChallenge> {
        return NSFetchRequest<YearlyChallenge>(entityName: "YearlyChallenge")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var year: Int64
    @NSManaged public var goal: Int64
    @NSManaged public var actualNumber: Int64
    
    public var year_int: Int {
        Int(year)
    }
    
    public var goal_int: Int {
        Int(goal)
    }
    
    public var actualNumber_int: Int {
        Int(actualNumber)
    }
    
    public var goalWasHit: Bool {
        actualNumber_int >= goal_int
    }
}

extension YearlyChallenge : Identifiable {

}
