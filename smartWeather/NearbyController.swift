//
//  NearbyController.swift
//  smartWeather
//
//  Created by Robs on 21/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var weatherData = [DayWeather]()
    var weatherGroup: WeatherGroup!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    @IBOutlet weak var tvLocations: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewControllerDidLoad")
        
        // setup the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        tvLocations.delegate = self
        tvLocations.dataSource = self
        
        //weatherGroup = ServiceManager.settingsService.getNearbyWeather(WeatherGroup.Sunny)
        weatherGroup = WeatherGroup.All
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
        loadNearbyWeather()
    }
    
    
    func loadNearbyWeather() {
        print("loadNearbyWeather")
        
        // request the current position
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        // new location received -> request the weather for this position
        currentLocation = newLocation
        locationManager.stopUpdatingLocation()
        
        if let location = ServiceManager.settingsService.getCurrentCityLocation() {
            loadNearbyWeatherForLocation(location)
        }
        else {
            loadNearbyWeatherForLocation(Location(position: Geoposition(lat: newLocation.coordinate.latitude, long: newLocation.coordinate.longitude)))
        }
    }
    
    func loadNearbyWeatherForLocation(location: Location) {
        print("load nearby weather for location: \(location.position)")
        
        //Abrufen des Orte im Umkreis zur aktuellen Position und mit Einschränkung auf das gewünschte Wetter
        ServiceManager.weatherService.getWeatherAroundPosition(location.position, maxCnt: 20, restrictToGroup: weatherGroup, completionHandler: nearbyWeatherLoaded,
            errorHandler:{(error: NSError) -> Void in
                print(error)
                //TODO: Meldung bez. Problem mit Wetter-Daten ausgeben
        })
    }
    
    func nearbyWeatherLoaded(weather: [DayWeather]) -> Void {
        print("weather data received: \(weather)")
                
        self.weatherData = weather
        updateUI()
    }
    
    func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            print("updateUI")
            
            self.tvLocations.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tvNearbyCell", forIndexPath: indexPath) as! nearbyTableViewCell
        let row = indexPath.row
        
        cell.lblLocationName.text = weatherData[row].location.name
        cell.lblWeatherDescription.text = weatherData[row].description
        
        // calculate distance
        let locEntry = CLLocation(latitude: weatherData[row].location.position.lat, longitude: weatherData[row].location.position.long)
        let distance = currentLocation.distanceFromLocation(locEntry)
        let distanceKm : Double = distance / 1000
        cell.lblDistance.text = String(format: "%.2f km", distanceKm)
        
        // weather icon
        if let icon = WeatherIcon.getIconForWeatherCode(weatherData[row].code) { //800 
            cell.lblWeatherIcon1.textColor = icon.parts[0].color
            cell.lblWeatherIcon1.text = icon.parts[0].iconChar
            
            if(icon.parts.count > 1) {
                cell.lblWeatherIcon2.textColor = icon.parts[1].color
                cell.lblWeatherIcon2.text = icon.parts[1].iconChar
            } else {
                cell.lblWeatherIcon2.text = ""
            }
            
            if(icon.parts.count > 2) {
                cell.lblWeatherIcon3.textColor = icon.parts[2].color
                cell.lblWeatherIcon3.text = icon.parts[2].iconChar
            } else {
                cell.lblWeatherIcon3.text = ""
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        print("cell clicked: \(weatherData[row].location.position)")
        
        do {
        try ServiceManager.settingsService.setCurrentCityLocation(weatherData[row].location)
        } catch _ {
            print("cannot save location")
        }
        
        // goto main screen
        let tabController = self.view.window?.rootViewController as! UITabBarController
        tabController.selectedIndex = 0
    }
}

class nearbyTableViewCell : UITableViewCell {
    
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblWeatherDescription: UILabel!    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblWeatherIcon1: UILabel!
    @IBOutlet weak var lblWeatherIcon2: UILabel!
    @IBOutlet weak var lblWeatherIcon3: UILabel!
    
}