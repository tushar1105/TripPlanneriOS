//
//  TripExpenses+CoreDataProperties.swift
//  FinalExam_TusharSharma_8869110
//
//  Created by Tushar Sharma on 2024-08-16.
//
//

import Foundation
import CoreData


extension TripExpenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripExpenses> {
        return NSFetchRequest<TripExpenses>(entityName: "TripExpenses")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var expenseName: String?
    @NSManaged public var expenseAmount: Double
    @NSManaged public var one: TripInfo?

}

extension TripExpenses : Identifiable {

}
