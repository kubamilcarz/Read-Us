//
//  ChallengeDelegate.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/23/22.
//

import CoreData
import Foundation

extension DataManager {
    func startNewChallenge(moc: NSManagedObjectContext, year: Int, pledgedGoal: Int) {
        let newChallenge = YearlyChallenge(context: moc)
        newChallenge.id = UUID()
        newChallenge.year = Int64(year)
        newChallenge.actualNumber = 0
        newChallenge.goal = Int64(pledgedGoal)
                
        try? moc.save()
    }
    
    func updateChallenge(moc: NSManagedObjectContext, challenge: YearlyChallenge, newGoal: Int) {
        challenge.goal = Int64(newGoal)
        
        try? moc.save()
    }
}
