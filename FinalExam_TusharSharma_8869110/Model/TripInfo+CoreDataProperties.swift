//
//  TripInfo+CoreDataProperties.swift
//  FinalExam_TusharSharma_8869110
//
//  Created by Tushar Sharma on 2024-08-18.
//
//

import Foundation
import CoreData


extension TripInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripInfo> {
        return NSFetchRequest<TripInfo>(entityName: "TripInfo")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var tripDestination: String?
    @NSManaged public var tripDestinationLatitude: Double
    @NSManaged public var tripDestinationLongitude: Double
    @NSManaged public var tripEndDate: Date?
    @NSManaged public var tripName: String?
    @NSManaged public var tripSource: String?
    @NSManaged public var tripSourceLatitude: Double
    @NSManaged public var tripSourceLongitude: Double
    @NSManaged public var tripStartDate: Date?
    @NSManaged public var tripDescription: String?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for expenses
extension TripInfo {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: TripExpenses)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: TripExpenses)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

extension TripInfo : Identifiable {

}
