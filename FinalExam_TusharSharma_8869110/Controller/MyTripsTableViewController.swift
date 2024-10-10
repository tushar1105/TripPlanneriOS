//
//  MyTripsTableViewController.swift
//  FinalExam_TusharSharma_8869110
//
//  Created by Tushar Sharma on 2024-08-16.
//
// table view controller to list all trips as custom table view cells.
import UIKit
import CoreData

class MyTripsTableViewController: UITableViewController {
    
    // trips is an array of trips.
    var myTrips : [TripInfo]?
    
    //reference object to manage content.
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var tripTableView: UITableView!
    @IBOutlet weak var searchValue: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripTableView.delegate = self
        tripTableView.dataSource = self
        fetchTrips()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchTrips()  // Refresh data when the view reappears
    }
    
    // custom functions.
    func fetchTrips() {
        do{
            self.myTrips = try content.fetch(TripInfo.fetchRequest())
            DispatchQueue.main.async {
                self.tripTableView.reloadData()
            }
        }catch{
            print("no data")
        }
    }
    
   
    
    //IB Actions
    // search : reference ChatGPT.
    @IBAction func searchTrip(_ sender: UIButton) {
        guard let searchText = searchValue.text?.lowercased(), !searchText.isEmpty else {
            fetchTrips() // If search is empty, fetch all trips
            return
        }
        
        let fetchRequest: NSFetchRequest<TripInfo> = TripInfo.fetchRequest()
        // Filter trips based on the trip name
        fetchRequest.predicate = NSPredicate(format: "tripName CONTAINS[cd] %@", searchText)
        
        do {
            self.myTrips = try content.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.tripTableView.reloadData()
            }
        } catch {
            print("Error fetching filtered trips: \(error.localizedDescription)")
        }
        searchValue.resignFirstResponder()
    }
    
    
    @IBAction func resetSearch(_ sender: UIButton) {
        searchValue.text = ""
        fetchTrips()
        searchValue.resignFirstResponder()
        
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchValue.resignFirstResponder()
        guard let searchText = searchValue.text?.lowercased(), !searchText.isEmpty else {
            fetchTrips() // If search is empty, fetch all trips
            return
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.myTrips?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripCustomTableViewCell
        let data = self.myTrips![indexPath.row]
        //configre custom cell
        cell.tripName.text = data.tripName!
        cell.tripSource.text = data.tripSource!
        cell.tripDestination.text = data.tripDestination!
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Create the alert controller
            let alert = UIAlertController(title: "Delete Trip", message: "Are you sure you want to delete this trip?", preferredStyle: .alert)
            
            // Add the "Delete" action
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                // Delete the row from the data source
                let tripToDelete = self.myTrips![indexPath.row]
                self.content.delete(tripToDelete)
                
                // Save the context
                do {
                    try self.content.save()
                } catch {
                    print("Error saving data")
                }
                
                // Remove the trip from the array and delete the row from the table view
                self.myTrips?.remove(at: indexPath.row)
                self.tripTableView.deleteRows(at: [indexPath], with: .fade)
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

    
    //     Override to support rearranging the table view
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        guard let movedTrip = myTrips?.remove(at: fromIndexPath.row) else { return }
        myTrips?.insert(movedTrip, at: to.row)
    }
    
    // Enable rearranging
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //accesory button pressed.
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // perform segue to details view.
        performSegue(withIdentifier: "tripDetails", sender: indexPath)
    }
    
    // MARK: - Navigation
    // pass the selected row as an object of TaskDetail class to the destination view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            if let destinationVC = segue.destination as? TripDetailsViewController {
                destinationVC.tripDetail = myTrips?[indexPath.row]
            }
        }
    }
    
}
