//
//  TripDirectionsViewController.swift
//  FinalExam_TusharSharma_8869110
//
//  Created by Tushar Sharma on 2024-08-16.
// controller to display the navigation between the source and destination.

import UIKit
import CoreLocation
import MapKit

class TripDirectionsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // custom varibales used for processing.
    var locationManager = CLLocationManager()
    // variables to store source and destination coordinates.
    var sourceCoordinates : CLLocationCoordinate2D?
    var destinationCoordinates : CLLocationCoordinate2D?
    var sourceName : String?
    var destinationName : String?
    // array of transport mode buttons
    var transpostModebuttons :[UIButton]?
    // selected trip.
    var tripDetail : TripInfo?
    
    // IB outlets
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var mapZoomSlider: UISlider!
    @IBOutlet weak var totalDistanceValue: UILabel!
    @IBOutlet weak var transportCar: UIButton!
    @IBOutlet weak var transportBike: UIButton!
    @IBOutlet weak var transportWalk: UIButton!
    @IBOutlet weak var transportTransit: UIButton!
    @IBOutlet weak var expectedTime: UILabel!
    @IBOutlet weak var tripSouce: UILabel!
    @IBOutlet weak var tripDestination: UILabel!
    
    
    
    
    // override functions.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        //
        sourceCoordinates = CLLocationCoordinate2D(latitude: tripDetail!.tripSourceLatitude, longitude: tripDetail!.tripSourceLongitude)
        destinationCoordinates = CLLocationCoordinate2D(latitude: tripDetail!.tripDestinationLatitude, longitude: tripDetail!.tripDestinationLongitude)
        sourceName = tripDetail!.tripSource
        destinationName = tripDetail!.tripDestination
        transpostModebuttons = [transportCar, transportBike, transportWalk, transportTransit]
        self.tripSouce.text = self.sourceName
        self.tripDestination.text = self.destinationName
        checkAndExecuteRouteToDestination()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        myMapView.delegate = self
        checkAndExecuteRouteToDestination()
    }
    
    // get directions if both source and destination are valid coordinates.
    //    // default mode of transport is automobile- car.
    func checkAndExecuteRouteToDestination() {
        if let sourceCoordinates = sourceCoordinates, let destinationCoordinates = destinationCoordinates {
            // map this function takes the source, destination coordinates and the mode of transport selected by the user to display the directions.
            routeToDestination(sourceCoordinates: sourceCoordinates, destinationCoordinates: destinationCoordinates, transportType: .automobile, transportMode : "Driving",transportModeButton : transpostModebuttons![0])
        }
    }
    //
    //    // mode of transport selected: car.
    @IBAction func modeOfTransportCar(_ sender: UIButton) {
        if let sourceCoordinates = sourceCoordinates, let destinationCoordinates = destinationCoordinates {
            // map this function takes the source, destination coordinates and the mode of transport selected by the user to display the directions.
            routeToDestination(sourceCoordinates: sourceCoordinates, destinationCoordinates: destinationCoordinates, transportType: .automobile,transportMode : "Driving",transportModeButton : sender)
        }
    }
    //
    //    // mode of transport selected: bike- cycle.
    //    // the mapkit was not showing the .cycle mode, so I have used .walking as the transport mode for this as well.
    //    // the view displays the mode as Cycle.
    @IBAction func modeOfTransportBike(_ sender: UIButton) {
        if let sourceCoordinates = sourceCoordinates, let destinationCoordinates = destinationCoordinates {
            // map this function takes the source, destination coordinates and the mode of transport selected by the user to display the directions.
            routeToDestination(sourceCoordinates: sourceCoordinates, destinationCoordinates: destinationCoordinates, transportType: .walking,transportMode : "Cycling",transportModeButton : sender)
        }
    }
    //
    //    // mode of transport selected: walk.
    @IBAction func modeOfTransportWalk(_ sender: UIButton) {
        if let sourceCoordinates = sourceCoordinates, let destinationCoordinates = destinationCoordinates {
            // map this function takes the source, destination coordinates and the mode of transport selected by the user to display the directions.
            routeToDestination(sourceCoordinates: sourceCoordinates, destinationCoordinates: destinationCoordinates, transportType: .walking,transportMode : "Walking",transportModeButton : sender)
        }
    }
    //
    //
    //    // mode of transport selected: public transit.
    //    // note: the transit mode did not return any routes even when tested with locations which have an exsting transit system, the problem could not be resolved.
    @IBAction func modeOfTransportPublic(_ sender: UIButton) {
        if let sourceCoordinates = sourceCoordinates, let destinationCoordinates = destinationCoordinates {
            // map this function takes the source, destination coordinates and the mode of transport selected by the user to display the directions.
            routeToDestination(sourceCoordinates: sourceCoordinates, destinationCoordinates: destinationCoordinates, transportType: .transit,transportMode : "Transit",transportModeButton : sender)
        }
    }
    
    //    // set border to the transport mode button clicked for easy identification.
    func setBorder(for selectedButton: UIButton) {
        for button in transpostModebuttons! {
            if button == selectedButton {
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.borderWidth = 2.0
                button.layer.cornerRadius = 10.0
            } else {
                button.layer.borderColor = UIColor.clear.cgColor
                button.layer.borderWidth = 0.0
            }
        }
    }
    //
    //
    //    // increase and decrease the zoom level of the map according to the change in the slider value.
    @IBAction func mapZoomSlider(_ sender: UISlider) {
        let centerCoordinate = myMapView.region.center
        
        // Convert slider value to zoom level
        // reference chatGPT.
        let zoomLevel = Double(mapZoomSlider.value)
        let latitudinalMeters = 1000 * pow(2, (100 - zoomLevel) / 10)
        let longitudinalMeters = 1000 * pow(2, (100 - zoomLevel) / 10)
        
        //        // Set new region
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
        myMapView.setRegion(region, animated: true)
    }
    
    // function to map the route from source to destination, based on the transport type passed in as an argument.
    //    // reference code based shared in the course content.
    func routeToDestination(sourceCoordinates: CLLocationCoordinate2D, destinationCoordinates : CLLocationCoordinate2D, transportType : MKDirectionsTransportType, transportMode : String, transportModeButton : UIButton) {
        //            print("mapthis....")
        //            print(sourceCoordinates)
        //            print(destinationCoordinates)
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinates)
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        destinationRequest.transportType = transportType
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            // to ensure that all view updations take place in the main thread of the application execution.
            DispatchQueue.main.async {
                if error != nil {
                    // print("Error calculating directions: \(error.localizedDescription)")
                    let errorAlert = UIAlertController(title: "Error", message: "Sorry! No routes available for the requested destination.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                    // clear all previous routes and values.
                    self.myMapView.removeOverlays(self.myMapView.overlays)
                    self.totalDistanceValue.text = ""
                    self.mapZoomSlider.value = 50
                    self.expectedTime.text = ""
                    self.setBorder(for: transportModeButton)
                    return
                }
                
                guard let response = response else {
                    // print("No response found")
                    return
                }
                
                if response.routes.isEmpty {
                    // print("No routes found")
                    return
                }
                
                // Remove any previous overlays
                self.myMapView.removeOverlays(self.myMapView.overlays)
                
                // Remove any previous annotations
                self.myMapView.removeAnnotations(self.myMapView.annotations)
                
                // Get the first route
                let route = response.routes[0]
                
                // Add the route overlay to the map
                self.myMapView.addOverlay(route.polyline)
                
                // Calculate region to fit the route
                var regionRect = route.polyline.boundingMapRect
                let wPadding = regionRect.size.width * 0.25
                let hPadding = regionRect.size.height * 0.25
                
                // Add padding to the region
                regionRect.size.width += wPadding
                regionRect.size.height += hPadding
                
                // Center the region on the map
                regionRect.origin.x -= wPadding / 2
                regionRect.origin.y -= hPadding / 2
                
                self.myMapView.setRegion(MKCoordinateRegion(regionRect), animated: true)
                
                // Add a pin for the source
                let sourcePin = MKPointAnnotation()
                sourcePin.coordinate = self.sourceCoordinates!
                sourcePin.title = self.sourceName
                self.myMapView.addAnnotation(sourcePin)
                
                // Add a pin for the destination
                let destinationPin = MKPointAnnotation()
                destinationPin.coordinate = destinationCoordinates
                destinationPin.title = self.destinationName
                self.myMapView.addAnnotation(destinationPin)
                
                // Calculate and display the travel time
                let travelTime = route.expectedTravelTime
                let hours = Int(travelTime) / 3600
                let minutes = (Int(travelTime) % 3600) / 60
                if(hours > 0){
                    self.expectedTime.text = hours.formatted()+" h " + minutes.formatted()+" m"
                }else{
                    self.expectedTime.text = minutes.formatted()+" min"
                }
                self.totalDistanceValue.text = String(format: "%.2f km", route.distance / 1000)
                self.tripSouce.text = self.sourceName
                self.tripDestination.text = self.destinationName
                
                // Set display values
                // Enable transport options
                self.transportCar.isEnabled = true
                self.transportBike.isEnabled = true
                self.transportWalk.isEnabled = true
                self.transportTransit.isEnabled = true
                // border around the selected transport mode button.
                self.setBorder(for: transportModeButton)
            }
        }
    }
    //
    //    // funciton to reate a polyline overlay to denote the route from source to destination.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let routeline = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        routeline.strokeColor = .blue
        return routeline
    }
}
