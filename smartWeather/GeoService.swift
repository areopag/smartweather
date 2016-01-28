//
//  GeoService.swift
//  smartWeather
//
//  Created by Florian on 21/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation
import CoreLocation

class GeoService: GeoServiceProtocol {
    lazy var locationManager:CLLocationManager = CLLocationManager()
        
    func getCurrentPosition(completionHandler: Geoposition -> Void, errorHandler: NSError -> Void) {
        
        //locationManager.requestWhenInUseAuthorization()
        
        if let location = locationManager.location {
            completionHandler(GeoService.geopositionFromCoreLocation(location))
        }
        else {
            let geoServiceDelegate = GeoSerivceDelegate(completionHandler: completionHandler, errorHandler: errorHandler)
            locationManager.delegate = geoServiceDelegate
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            
        }
    }
    
    class func geopositionFromCoreLocation(coreLocation: CLLocation) -> Geoposition {
        return Geoposition(lat: coreLocation.coordinate.latitude, long: coreLocation.coordinate.longitude)
    }
}


private class GeoSerivceDelegate:NSObject, CLLocationManagerDelegate {
    let completionHandler: Geoposition -> Void
    let errorHandler: NSError -> Void
    
    init(completionHandler: Geoposition -> Void, errorHandler: NSError -> Void) {
        self.completionHandler = completionHandler
        self.errorHandler = errorHandler
    }
    
    @objc func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //completionHandler(CLLocation())
        print("new locationManager status: \(status)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print("locationManager: new location!")
        manager.stopUpdatingLocation()
        completionHandler(GeoService.geopositionFromCoreLocation(newLocation))
    }
    
    @objc private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        //errorHandler(error)
    }
    
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            manager.stopUpdatingLocation()
            completionHandler(GeoService.geopositionFromCoreLocation(locations[0]))
        }
    }
}