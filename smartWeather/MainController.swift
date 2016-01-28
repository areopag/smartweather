//
//  MainController.swift
//  smartWeather
//
//  Created by Robs on 17/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import UIKit
import CoreLocation
import CoreSpotlight
import MobileCoreServices

class MainController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblSummaryState: UILabel!
    @IBOutlet weak var lblIcon: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var pcDay: UIPageControl!
    
    var animatedStateIcon: UIImageView!
    @IBOutlet weak var lblIcon2: UILabel!
    @IBOutlet weak var lblIcon3: UILabel!
    
    var locationManager: CLLocationManager!
    
    var currentWeatherData: [DayWeather]!
    var currentDay: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewControllerDidLoad")
        
        // read the cities list from file into the database
        //ServiceManager.databaseService.updateCitiesList()
        
        // set the background image
        setBackgroundImage("sunny.jpg")
        
        // add handlers for some gestures
        addGestureHandlers()
        
        // setup the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // add entry for spotlight serach
        addSpotlightSearch("weather", description: "The really smart weather app.")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
        // initital day (0 = current day)
        currentDay = 0
        loadWeather()
    }
        
    func addGestureHandlers() {
        // add swipe gesture recognizers
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        swipeLeft.direction = .Left
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
        
        // add tap gesture recognizer
        let tapDoubleGesture = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"))
        tapDoubleGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapDoubleGesture)
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if(sender.direction == .Right) {
            print("swipeLeft")
            if(currentDay > 0) {
                currentDay--
                updateUI()
            }
        }
        else if(sender.direction == .Left) {
            print("swipeRight")
            if(currentDay < 6) {
                currentDay++
                updateUI()
            }
        }
    }
    
    func handleDoubleTap(sender:UITapGestureRecognizer) {
        print("reload weather")
        loadWeather()
    }
    
    func setBackgroundImage(filename:String) {
        let bgImage = UIImage(named: filename)
        let ratio = bgImage!.size.width / bgImage!.size.height
        let newWidth = self.view.bounds.height * ratio
        let newHeight = self.view.bounds.height
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        bgImage?.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        
        let bgImageNew: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: bgImageNew)
    }
    
    func loadWeather() {
        print("loadWeather")
        
        if let location = ServiceManager.settingsService.getCurrentCityLocation() {
            loadWeatherForLocation(location)
        }
        else {
            print("requesting location...")
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func loadWeatherForLocation(location: Location) {
        print("loadWeatherForLocation")
        
        ServiceManager.weatherService.getUpcomingWeatherForLocation(location, completionHandler: weatherLoaded, errorHandler: { (error:NSError) -> Void in
            print(error)
            //TODO: Meldung bez. Problem mit Wetter-Daten ausgeben
        })
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        // new location received -> request the weather for this position
        print("new location received: \(newLocation)")
        loadWeatherForLocation(Location(position: Geoposition(lat: newLocation.coordinate.latitude, long: newLocation.coordinate.longitude)))
        locationManager.stopUpdatingLocation()
    }
    
    
    func weatherLoaded(weather: [DayWeather]) -> Void {
        print("Weather data received")
        
        currentWeatherData = weather
        updateUI()
    }
    
    func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            if(self.currentWeatherData.count > self.currentDay) {
                let weather = self.currentWeatherData[self.currentDay]
                print("updateUI")
        
                // format the date
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "EEEE"
                let dateString = dateFormatter.stringFromDate(weather.day)
        
                // update the labels
                self.lblTitle.text = "\(dateString)"
                self.lblDetails.text = "\(weather.temp) °C / \(weather.humi) %"
                self.lblLocation.text = weather.location.name
                self.lblSummaryState.text =  weather.description
    
                // set the pageview index
                self.pcDay.currentPage = self.currentDay
            
                // update the icon
                print(weather.code)
            
                if let icon = WeatherIcon.getIconForWeatherCode(weather.code) { //800 = Sonnig
                    self.lblIcon.font = UIFont(name: "iconvault", size: 200)
                    self.lblIcon.textColor = icon.parts[0].color
                    self.lblIcon.text = icon.parts[0].iconChar
                
                    if(icon.parts.count > 1) {
                        self.lblIcon2.textColor = icon.parts[1].color
                        self.lblIcon2.text = icon.parts[1].iconChar
                    } else {
                        self.lblIcon2.text = ""
                    }
                
                    if(icon.parts.count > 2) {
                        self.lblIcon3.textColor = icon.parts[2].color
                        self.lblIcon3.text = icon.parts[2].iconChar
                    }
                    else {
                        self.lblIcon3.text = ""
                    }
                }
            } else {
                // no weather data available
                self.lblTitle.text = "n/a"
                self.lblDetails.text = "n/a"
                self.lblLocation.text = "n/a"
                self.lblSummaryState.text =  "n/a"
            }
        }
    }
        
    func addSpotlightSearch(title: String, description: String) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = "weather"
        attributeSet.contentDescription = "The really smart weather app."
        
        let item = CSSearchableItem(uniqueIdentifier: "smartweather1", domainIdentifier: "at.fhj.ims14", attributeSet: attributeSet)
        
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) {
            (error: NSError?) -> Void in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item indexed")
            }
        }
    }
}

