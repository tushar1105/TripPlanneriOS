# READ-ME: Travel Buddy iOS App - Tushar Sharma

## Application Overview

    - The application aims to be the perfect tool to plan and manage trips for the users.
    
    - The application provides the users with options to add a new trip, along with the expenses related to each trip.
    
    - Based on the source and destination, the users can also view the directions, total distance and time for the trip aswell as the current weather information at the destination.
    
    - The user can toggle between various modes of transport to decide on the route and all display values change dynamically.
    
    - A slider has been provided to allow the user to smoothly zoom in and out of the map for better usability.
    
    - The user can also search for a trip based on the trip name from the list of all trips.
    
    - The application uses CoreData to provide data persistence across sessions.
    
    - The application provides descriptive alert messages to the user informing about the system responses based on his actions.

    - For greater code readability, the code files are organised into logical folders namely - Model, View, Controller and Utilities and class files contain descriptive comments for the functionality of modules and references if any.

## Application Structure

### Model
    - APICall: Structure containing the required components of the API call as properties with the initial values, the request string is sent over as and when required during object creation.
    - WeatherAPI: Structure to represent the API response received from the openweather API.
    - TripInfo : model class to store trip details based on the related attributes, also has a one to many relationship with the TripExpenses model.
    - TripExpenses : model to store the trip expenses related to each trip. 
    
    
### View
    - LaunchScreen: The first screen displayed when the application is launched.
    - Main: The main view - a navigation controller with the following views - 
     - MyTrips: the tableview containing the list of all trips as custom cells.
     - AddTrip: the view to add a new trip.
     - TripDetails: the view the details related to a selected trip.
        - TripWeather: view to display the current weather information for the destination.
        - TripDirections: view to display the navigation between source and destination.
     - AddExpenses: view to add expenses for a particular trip.

### Controller
    - AddExpensesViewController: the controller to add expenses to a trip.
    - AddTripViewController: controller to add a new trip.
    - MyTripsTableViewController: table view controller to list all trips as custom table view cells.
        - TripCustomTableViewCell: custom table view cell.
    - TripDetailsViewController: controller to display information related to a selected trip.
    - TripDirectionsViewController: controller to display the navigation between the source and destination.
    - TripWeatherViewController: controller to display the current weather information at the destination using the openweather API.
    
    
    
## Key learning outcomes for me from the task

- Succesfull implementaion of OpenWeather API and Maps in an app to display weather and allow navigation.
- Implementing CLGeocoder() which converts a text into the corresponding coordinates out of the box.
    - also, it is an Asynchronous method which means that its execution is independent and on a different thread to that of the main application, executing it successfully was a challenge.
- Learnt about the Dispatch queue and how multithreading is implemented in the app, for the changes to be reflected in the main UI everything has to be synchronised to work on the main thread.
- Succesfull implementaion of CoreData as a persistent data storage.
    - relationships between entities, and fetching values based on conditions (predicates).

    
        
        
