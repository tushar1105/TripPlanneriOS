//
//  TripDetailsViewController.swift
//  FinalExam_TusharSharma_8869110
//
//  Created by Tushar Sharma on 2024-08-16.
//
// controller to display information related to a selected trip.
import UIKit
import CoreData

class TripDetailsViewController: UIViewController {
    
    //custom variables.
    var tripDetail : TripInfo?
    //reference object to manage content.
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //IB Outlets
    @IBOutlet weak var tripExpense: UILabel!
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var tripSource: UILabel!
    @IBOutlet weak var tripDestination: UILabel!
    @IBOutlet weak var tripStartDate: UILabel!
    @IBOutlet weak var tripEndDate: UILabel!
    @IBOutlet weak var tripDescription: UILabel!
    
    
    // override functions.
    override func viewDidLoad() {
        super.viewDidLoad()
        let totalExpense = calculateTotalExpense(for: tripDetail!)
        // Round off to two decimal places and update the totalExpense outlet.
        tripExpense.text = String(format: "$%.2f CAD", totalExpense)
        // setting all values to outlets.
        tripName.text = tripDetail!.tripName
        tripSource.text = tripDetail!.tripSource
        tripDestination.text = tripDetail!.tripDestination
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        if let startDate = tripDetail?.tripStartDate {
            tripStartDate.text = dateFormatter.string(from: startDate)
        }
        
        if let endDate = tripDetail?.tripEndDate {
            tripEndDate.text = dateFormatter.string(from: endDate)
        }
        
        if let description = tripDetail?.tripDescription {
            tripDescription.text = description
        }else{
            tripDescription.text = "-"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let totalExpense = calculateTotalExpense(for: tripDetail!)
        // Round off to two decimal places and update the totalExpense outlet.
        tripExpense.text = String(format: "$%.2f CAD", totalExpense)
        // setting all values to outlets.
        tripName.text = tripDetail!.tripName
        tripSource.text = tripDetail!.tripSource
        tripDestination.text = tripDetail!.tripDestination
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        if let startDate = tripDetail?.tripStartDate {
            tripStartDate.text = dateFormatter.string(from: startDate)
        }
        
        if let endDate = tripDetail?.tripEndDate {
            tripEndDate.text = dateFormatter.string(from: endDate)
        }
    }
    
    // custome functions.
    // refernce chatgpt to calculte the total expense.
    func calculateTotalExpense(for trip: TripInfo) -> Double {
        // Fetch the expenses related to the selected trip
        let fetchRequest: NSFetchRequest<TripExpenses> = TripExpenses.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "one == %@", trip)
        
        do {
            let expenses = try content.fetch(fetchRequest)
            // Sum up the expense amounts
            let totalExpense = expenses.reduce(0.0) { $0 + $1.expenseAmount }
            return totalExpense
        } catch {
            print("Error calculating total expense: \(error.localizedDescription)")
            return 0.0
        }
    }
    
    // IB Actions.
    @IBAction func tripDirections(_ sender: UIButton) {
        performSegue(withIdentifier: "tripDirections", sender: self)
    }
    
    
    @IBAction func tripWeather(_ sender: UIButton) {
        performSegue(withIdentifier: "tripWeather", sender: self)
    }
    
    
    
    // MARK: - Prepare for segue based on the button clicked.
    
    // Prepare for the segue and pass data to the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tripDirections" {
            if let destinationVC = segue.destination as? TripDirectionsViewController {
                destinationVC.tripDetail = tripDetail
            }
        } else if segue.identifier == "tripWeather" {
            if let destinationVC = segue.destination as? TripWeatherViewController {
                destinationVC.tripDetail = tripDetail
            }
        }else if segue.identifier == "tripExpenses" {
            if let destinationVC = segue.destination as? AddExpensesViewController {
                destinationVC.tripDetail = tripDetail
            }
        }
    }
}
