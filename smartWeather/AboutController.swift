//
//  AboutController.swift
//  smartWeather
//
//  Created by Robs on 21/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//
//  Controller for the Aboud view
//

import UIKit
import CoreLocation

class AboutController: UIViewController, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var imgCompass: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewControllerDidLoad")
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading.magneticHeading)
        
        let orientation = UIDevice.currentDevice().orientation.rawValue
        var correction : Float
        
        switch(orientation) {
        case 2: // landscape
            correction = 180
        case 3: // portrait
            correction = 270
        case 4: // portrait
            correction = 90
        case 5: // landscape
            correction = 0
        default:
            correction = 0
        }
        
        let degrees = Float(newHeading.magneticHeading) - correction
        let rotation = -degrees * Float(M_PI) / 180
        
        // rotate the image
        imgCompass.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
    }
    
    @IBAction func btUpdateWeatherStations(sender: AnyObject) {
        // read the cities list from file into the database
        print("update weather station list")
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            ServiceManager.databaseService.updateCitiesList()
            dispatch_async(dispatch_get_main_queue()) {
                print("weather station update completed")
            }
        }
    }
}
