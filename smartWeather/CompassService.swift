//
//  CompassService.swift
//  smartWeather
//
//  Created by Maderbacher Florian on 06/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation
import CoreMotion

class CompassService: CompassServiceProtocol  {
    func registerCompass(compassChanged: CompassState -> Void) {
        let motionManager = CMMotionManager()
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!) { (data: CMGyroData?, error:NSError?) -> Void in
            if let data = data {
                let state = CompassState()
                state.active = true
                state.ratio = data.rotationRate.x
            }else{
                print(error)
            }
        }
    }
    
    func filterLocations(compassState: CompassState, position: Geoposition, locations: [Location]) -> [Location] {
        if(compassState.active) {
            let filteredLocations = [Location]()
            //TODO: Auf Basis der aktuellen Position und der Ausrichtung die übergebenen Ort einschränken
            return filteredLocations
        }
        else {
            return locations
        }
    }
}