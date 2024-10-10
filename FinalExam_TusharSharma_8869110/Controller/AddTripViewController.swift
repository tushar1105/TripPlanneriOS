//
//  AddTripViewController.swift
//  FinalExam_TusharSharma_8869110
//
//  Created by Tushar Sharma on 2024-08-16.
//
// controller to add a new trip.
import UIKit
import CoreData
import CoreLocation
import MapKit


class AddTripViewController: UIViewController {
    
    // custom variables.
    var sourceCoordinates : CLLocationCoordinate2D?
    var destinationCoordinates : CLLocationCoordinate2D?
    
    
    // IB outlets.
    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripStartLocation: UITextField!
    @IBOutlet weak var tripDestinationLocation: UITextField!
    @IBOutlet weak var tripStartDate: UIDatePicker!
    @IBOutlet weak var tripEndDate: UIDatePicker!
    @IBOutlet weak var tripDescription: UITextField!
    @IBOutlet weak var addTrip: UIButton!
    
    
    //reference object to manage content.
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // override functions.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        tripStartDate.date = Date()
        tripStartDate.minimumDate = Date()
        tripEndDate.date = Date()
        tripEndDate.minimumDate = Date()
    }
    
    // custom functions.
    // converts address from text to coordinates Longtide and latitude
    // source ChatGPT : the funciton returned nil even when the coordinates were calculated, this was due to the asychronous nature of the geocodeAddressString method, using the code block below, the function returns only when that asychronous call has been completed.
    //The @escaping keyword is used because the closure might be called after the convertAddress function has returned. Without @escaping, the closure cannot outlive the scope of the function, which would not be suitable for asynchronous operations like network requests or geocoding.
    func convertAddress(textInput: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(textInput) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location else {
                //                print("No location found")
                // alert to inform user that the location name is invalid.
                let invalidLocation = UIAlertController(title: "Error", message: "Please enter a valid location name.", preferredStyle: .alert)
                invalidLocation.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(invalidLocation, animated: true, completion: nil)
                // disable add trip button.
                self.addTrip.isEnabled = false
                //
                completion(nil)
                return
            }
            let calculatedCoordinates = location.coordinate
            // print("calculatedCoordinatesInside: \(calculatedCoordinates)")
            self.addTrip.isEnabled = true
            completion(calculatedCoordinates)
        }
    }
    
    // check all mandatory values.
    func checkMandatoryFields() -> Bool {
        if((tripName.text == nil || tripName.text!.isEmpty) || (tripStartLocation.text == nil || tripStartLocation.text!.isEmpty) || (tripDestinationLocation.text == nil || tripDestinationLocation.text!.isEmpty)){
            return false;
        }else{
            return true;
        }
    }
    
    // IB Actions.
    // check for source if it is a valid locaiton.
    @IBAction func startLocationCheck(_ sender: UITextField) {
        //        print("here...s")
        let startLocation = tripStartLocation.text
        if startLocation != nil && !startLocation!.isEmpty {
            self.convertAddress(textInput: startLocation!) { coordinates in
                if let coordinates = coordinates {
                    self.sourceCoordinates = coordinates
                }
            }
        }
    }
    
    // check for destination if it is a valid locaiton.
    @IBAction func destinationLocationCheck(_ sender: UITextField) {
        //        print("here...d")
        let destinationLocation = tripDestinationLocation.text
        if destinationLocation != nil && !destinationLocation!.isEmpty {
            self.convertAddress(textInput: destinationLocation!) { coordinates in
                if let coordinates = coordinates {
                    self.destinationCoordinates = coordinates
                }
            }
        }
    }
    
    @IBAction func addTrip(_ sender: UIButton) {
        // fetch values and save to CoreData.
        if(checkMandatoryFields()){
            let tripStartDate = tripStartDate.date
            let tripEndDate = tripEndDate.date
            // Check if the end date is less than the start date
            if tripEndDate < tripStartDate {
                // display alert to let user know.
                let dateError = UIAlertController(title: "Error", message: "Trip end date should be greater than or equal to the start date.", preferredStyle: .alert)
                dateError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dateError, animated: true, completion: nil)
            }else{
                let tripName = tripName.text
                let tripSource = tripStartLocation.text
                let tripDestination = tripDestinationLocation.text
                let tripStartLatitude = sourceCoordinates?.latitude
                let tripStartLongitude = sourceCoordinates?.longitude
                let tripDestinationLatitude = destinationCoordinates?.latitude
                let tripDestinationLongitude = destinationCoordinates?.longitude
                let tripDescription = tripDescription.text
                
                let newTrip = TripInfo(context: self.content)
                newTrip.id = UUID()
                newTrip.tripName = tripName
                newTrip.tripSource = tripSource
                newTrip.tripDestination = tripDestination
                newTrip.tripStartDate = tripStartDate
                newTrip.tripEndDate = tripEndDate
                newTrip.tripSourceLatitude = tripStartLatitude!
                newTrip.tripSourceLongitude = tripStartLongitude!
                newTrip.tripDestinationLatitude = tripDestinationLatitude!
                newTrip.tripDestinationLongitude = tripDestinationLongitude!
                newTrip.tripDescription = tripDescription!
                
                // save the data
                do{
                    try self.content.save()
                    let tripAdded = UIAlertController(title: "Success", message: "Trip Added Successfully.", preferredStyle: .alert)
                    tripAdded.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(tripAdded, animated: true, completion: nil)
                }catch{
                    print("Error saving data")
                }
            }
        }else{
            // display alert to let user know that all values have not been entered.
            let mandatoryFields = UIAlertController(title: "Error", message: "Fields marked with (*) are mandatory.", preferredStyle: .alert)
            mandatoryFields.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(mandatoryFields, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func resetValues(_ sender: UIButton) {
        // reset all values.
        tripName.text = ""
        tripStartLocation.text = ""
        tripDestinationLocation.text = ""
        tripStartDate.date = Date()
        tripStartDate.minimumDate = Date()
        tripEndDate.date = Date()
        tripEndDate.minimumDate = Date()
        sourceCoordinates = nil
        destinationCoordinates = nil
        // display alert to let user know that all values have been reset.
        let resetAlert = UIAlertController(title: "Reset", message: "All values have been reset to default values.", preferredStyle: .alert)
        resetAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(resetAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        tripName.resignFirstResponder()
        tripStartLocation.resignFirstResponder()
        tripDestinationLocation.resignFirstResponder()
        tripDescription.resignFirstResponder()
    }
}
