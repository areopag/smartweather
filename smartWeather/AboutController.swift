//
//  AboutController.swift
//  smartWeather
//
//  Created by Robs on 21/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
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
        let degrees = Float(_builtinFloatLiteral: newHeading.magneticHeading.value)
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
