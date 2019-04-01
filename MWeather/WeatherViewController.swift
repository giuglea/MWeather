//
//  ViewController.swift
//  MWeather
//
//  Created by Andrei Giuglea on 01/04/2019.
//  Copyright © 2019 Andrei Giuglea. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController ,CLLocationManagerDelegate,ChangeCityDelegate{
    
    

    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "43df678043d8cb5104286dd98a4d05e2"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var changeCityLabel: UIButton!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        changeCityLabel.layer.cornerRadius = 15
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       
        
        let alert = UIAlertView.init(title: "Attention!", message: "Click on the image for more details", delegate: self,cancelButtonTitle: "OK")
        alert.show()
        addImageTapping()
        
        
        
        
    }
    func addImageTapping()  {
        
        weatherIcon.isUserInteractionEnabled = true
        let tapAction = UITapGestureRecognizer()
        tapAction.addTarget(self, action: #selector(imageTapped))
        weatherIcon.addGestureRecognizer(tapAction)
    }
    
    @objc func imageTapped(){
//        let alert = UIAlertView.init(title: "Info Weather", message: "\(weatherDataModel.weatherIconName))", delegate: self, cancelButtonTitle: "Don't Annoy Me!!")
//        alert.show()
    }
    
  
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationLabel.text = "Location Unavailable"
        print(error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("longitude - \(location.coordinate.longitude) , latitude - \(location.coordinate.latitude)")
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let params : [String : String] = ["lat" : String(latitude) , "lon" : String(longitude), "appid" : APP_ID]
            getWeatherData(url : WEATHER_URL,parameters : params)
        }
    }
        

    
    func getWeatherData(url : String , parameters : [String : String]){
        Alamofire.request(url,method : .get , parameters : parameters).responseJSON{
            response in
            if response.result.isSuccess{
                print("Succes")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON )
                self.updateUI()
                
            }
            else{
                print(response.result.error)
                self.locationLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateWeatherData(json :JSON){
        
        weatherDataModel.temperature =  json["main"]["temp"].int ?? 0
        weatherDataModel.temperature -= 273
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        print(json)
        
    }


    func updateUI(){
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        locationLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature) + "º"
    }
    
    func sendCityName(city: String) {
        print(city)
        let parameters: [String:String] = [ "q" : city , "appid" : APP_ID]
        
        self.getWeatherData(url: WEATHER_URL, parameters: parameters)
        
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChageCity" {
            let destinationVC = segue.destination as! ChangeCity
            destinationVC.delegate = self
        }
    }

}
