//
//  TripWeatherViewController.swift
//  FinalExam_TusharSharma_8869110
//
//  Created by Tushar Sharma on 2024-08-16.
//

import UIKit

class TripWeatherViewController: UIViewController {
    
    
    // custom variables
    var tripDetail : TripInfo?
    var customCityName : String?
    
    
    //IB Outlets
    @IBOutlet weak var currentCityName: UILabel!
    @IBOutlet weak var currentWeather: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var currentWindSpeed: UILabel!
    @IBOutlet weak var maximumTemperature: UILabel!
    @IBOutlet weak var minimumTemperature: UILabel!
    
    // override functions.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        customCityName = tripDetail!.tripDestination
        updateWeatherData()
    }
    
    
    // custom functions
    // function to update weather data on view.
    func updateWeatherData(){
        var finalAPIEndpointURL : String?
        // generate final API endpoint.
        // api call according to current latitude and longitude values.
        let requestString = "q=\(customCityName!)"
        let apiCall = APICall(apiRequestString: requestString)
        finalAPIEndpointURL = apiCall.completeAPIEndpoint()
        let urlSession = URLSession(configuration: .default)
        let url = URL(string: finalAPIEndpointURL!)
        // api call to receive data, response, error
        if let url = url {
            let dataTask = urlSession.dataTask(with: url) {
                (data, response, error) in
                //print(data!)
                //let jsonString = String(data: data!, encoding: .utf8)
                //print("Raw JSON data: \(jsonString!)")
                let jsonDecoder = JSONDecoder()
                do{
                    let readableData = try jsonDecoder.decode(WeatherAPI.self, from: data!)
                    //print(readableData)
                    let cityName = "\(readableData.name), \(readableData.sys.country)"
                    let weather = readableData.weather.first?.main ?? "No weather info"
                    // kelvin to celsius conversion.
                    let temperature = readableData.main.temp - 273.15
                    let maximumTemperature = readableData.main.tempMax - 273.15
                    let minimumTemperature = readableData.main.tempMin - 273.15
                    let formattedTemp = String(format: "%.0f", temperature)
                    let formattedMaximumTemperature = String(format: "%.0f", maximumTemperature)
                    let formattedMinimumTemperature = String(format: "%.0f", minimumTemperature)
                    // m/s to km/hr
                    let windSpeedKmH = readableData.wind.speed * 3.6
                    let formattedWindSpeed = String(format: "%.2f", windSpeedKmH)
                    let humidity = "\(readableData.main.humidity) %"
                    let iconCode = readableData.weather.first?.icon ?? "default_icon"
                    //                    print(iconCode)
                    //print("\(cityName),\(weather),\(formattedTemp)°C,\(formattedWindSpeed)km/hr,\(humidity)")
                    // updateing the view on the main thread with the received values.
                    DispatchQueue.main.async {
                        self.currentCityName.text = cityName
                        self.currentWeather.text = weather
                        self.currentTemperature.text = "\(formattedTemp) °C"
                        self.maximumTemperature.text = "\(formattedMaximumTemperature) °C"
                        self.minimumTemperature.text = "\(formattedMinimumTemperature) °C"
                        self.currentWindSpeed.text = "\(formattedWindSpeed) km/h"
                        self.currentHumidity.text = humidity
                        // Set the weather icon image based on the icon code
                        self.setWeatherIcon(iconCode: iconCode)
                        
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        let responseError = UIAlertController(title: "Error", message: "Sorry! Invalid location or city name.", preferredStyle: .alert)
                        responseError.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(responseError, animated: true, completion: nil)
                    }
                }
            }
            dataTask.resume()
        }
        
        
    }
    
    // function to set weather icon based on the returned icon code from API.
    // reference chatGPT.
    func setWeatherIcon(iconCode: String) {
        // Map iconCode to SF Symbol names
        let iconName: String
        switch iconCode {
        case "01d":
            iconName = "sun.max"
        case "01n":
            iconName = "moon.stars"
        case "02d":
            iconName = "cloud.sun"
        case "02n":
            iconName = "cloud.moon"
        case "03d":
            iconName = "cloud"
        case "03n":
            iconName = "cloud.moon"
        case "04d":
            iconName = "cloud.fill"
        case "04n":
            iconName = "cloud.fill"
        case "09d":
            iconName = "cloud.rain"
        case "09n":
            iconName = "cloud.rain"
        case "10d":
            iconName = "cloud.heavyrain"
        case "10n":
            iconName = "cloud.heavyrain"
        case "11d":
            iconName = "cloud.bolt.rain"
        case "11n":
            iconName = "cloud.bolt.rain"
        case "13d":
            iconName = "snow"
        case "13n":
            iconName = "snow"
        case "50d":
            iconName = "cloud.fog"
        case "50n":
            iconName = "cloud.fog"
        default:
            iconName = "questionmark"
        }
        // Set the image for the UIImageView
        weatherImage.image = UIImage(systemName: iconName)
    }
}
