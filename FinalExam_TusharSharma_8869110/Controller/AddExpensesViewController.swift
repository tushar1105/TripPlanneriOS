//
//  AddExpensesViewController.swift
//  FinalExam_TusharSharma_8869110
//
//  Created by Tushar Sharma on 2024-08-16.
//
// the controller to add expenses to a trip.
import UIKit
import CoreData

class AddExpensesViewController:  UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    // csutom variables.
    var tripDetail : TripInfo?
    // trips is an array of trips.
    var tripExpenses : [TripExpenses]?
    
    //reference object to manage content.
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // IB Outlets
    @IBOutlet weak var expenseType: UITextField!
    @IBOutlet weak var expenseAmount: UITextField!
    @IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet weak var totalExpense: UILabel!
    @IBOutlet weak var tripName: UILabel!
    
    //override functions.
    override func viewDidLoad() {
        super.viewDidLoad()
        expensesTableView.delegate = self
        expensesTableView.dataSource = self
        expenseAmount.delegate = self
        tripName.text = tripDetail!.tripName
        // fetch expenses based on the current trip object.
        fetchExpenses(for: tripDetail)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchExpenses(for: tripDetail)
        tripName.text = tripDetail!.tripName
    }
    
    // table view funcitons.
    // number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //    rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tripExpenses?.count ?? 0
    }
    
    // data  to be displayed in each cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseItem", for: indexPath)
        // Configure the cell...
        let data = self.tripExpenses![indexPath.row]
        cell.textLabel?.text = "Name: " + data.expenseName!
        cell.detailTextLabel?.text = "$" + data.expenseAmount.description + "CAD"
        return cell
    }
    
    // Enable editing for rows.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Create the alert controller
            let alert = UIAlertController(title: "Delete Expense", message: "Are you sure you want to delete this expense?", preferredStyle: .alert)
            
            // Add the "Delete" action
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                // Delete the row from the data source
                let expenseToDelete = self.tripExpenses![indexPath.row]
                self.content.delete(expenseToDelete)
                
                // Save the context
                do {
                    try self.content.save()
                } catch {
                    print("Error saving data")
                }
                
                // Remove the expense from the array and delete the row from the table view
                self.tripExpenses?.remove(at: indexPath.row)
                self.expensesTableView.deleteRows(at: [indexPath], with: .fade)
                self.fetchExpenses(for: self.tripDetail)
            }
            
            // Add the "Cancel" action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            // Add actions to the alert controller
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            // Present the alert controller
            present(alert, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
            // Handle the insert case (if needed)
        }
    }
    
    
    
    //  to support rearranging the table view
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        guard let movedTrip = tripExpenses?.remove(at: fromIndexPath.row) else { return }
        tripExpenses?.insert(movedTrip, at: to.row)
    }
    
    // Enable rearranging
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // custom functions.
    // function to check if all fields are filled by the user.
    func checkMandatoryFields() -> Bool {
        if((expenseType.text == nil || expenseType.text!.isEmpty) || (expenseAmount.text == nil || expenseAmount.text!.isEmpty)){
            return false;
        }else{
            return true;
        }
    }
    
    // function to calculate the total expense.
    // reference chatGPT.
    func fetchExpenses(for trip: TripInfo?) {
        guard let trip = trip else { return }
        
        let fetchRequest: NSFetchRequest<TripExpenses> = TripExpenses.fetchRequest()
        // Filter expenses to only include those related to the selected trip
        fetchRequest.predicate = NSPredicate(format: "one == %@", trip)
        
        do {
            self.tripExpenses = try content.fetch(fetchRequest)
            
            // Calculate total expense
            let total = self.tripExpenses?.reduce(0.0) { $0 + $1.expenseAmount } ?? 0.0
            
            // Round off to two decimal places and update the totalExpense outlet.
            self.totalExpense.text = String(format: "Total Expense: $%.2f CAD", total)
            
            DispatchQueue.main.async {
                self.expensesTableView.reloadData()
            }
        } catch {
            print("Error fetching expenses: \(error.localizedDescription)")
        }
    }
    
    // to prevent consecutive decimal inputs in amount field.
    // reference chatGPT.
    // If a decimal point is already present, the method returns false, preventing another one from being added.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check if the string contains a decimal point
        if string == "." {
            // Check if the text already contains a decimal point
            if textField.text?.contains(".") == true {
                return false
            }
        }
        return true
    }
    
    // IB Actions.
    // clear form values.
    @IBAction func clearValues(_ sender: UIButton) {
        expenseType.text = ""
        expenseAmount.text = ""
        let alert = UIAlertController(title: "Clear", message: "All inputs have been reset to default values.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    // add new expense item.
    @IBAction func addItem(_ sender: UIButton) {
        // check if both fields have a value.
        // Check if both fields have a value
        if checkMandatoryFields() {
            // Create a new TripExpenses object
            let newExpense = TripExpenses(context: content)
            
            // Set properties of the new expense
            newExpense.id = UUID() // Assign a new UUID
            newExpense.expenseName = expenseType.text
            if let amountText = expenseAmount.text, let amount = Double(amountText) {
                newExpense.expenseAmount = amount
            }
            
            // Set the relation to the current trip
            // reference chatGPT.
            if let currentTrip = tripDetail {
                newExpense.one = currentTrip
            }
            
            // Save the new expense to Core Data
            do {
                try content.save()
                
                // Update the expenses and total expense
                fetchExpenses(for: tripDetail)
                let success = UIAlertController(title: "Success", message: "\(expenseType.text!): $\(expenseAmount.text!) added Successfully.", preferredStyle: .actionSheet)
                
                let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
                    self.expensesTableView.reloadData()
                    self.expenseType.text = ""
                    self.expenseAmount.text = ""
                }
                success.addAction(okayAction)
                self.present(success, animated: true, completion: nil)
                
            } catch {
                print("Error saving expense: \(error.localizedDescription)")
            }
        } else {
            let errorAlert = UIAlertController(title: "Error", message: "Category or amount cannot be empty.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(errorAlert, animated: true, completion: nil)
        }
    }
    
    // dismiss keyboard.
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        expenseType.resignFirstResponder()
        expenseAmount.resignFirstResponder()
    }
    
    
}
