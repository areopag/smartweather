//
//  MapController.swift
//  smartWeather
//
//  Created by Robs on 22/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewControllerDidLoad")
        
        if let location = ServiceManager.settingsService.getCurrentCityLocation() {
            //TODO: Laden des Wetters falls gewünscht
            moveToPosition(location.position, name: location.name ?? "", weather: "")
        }
        else {
            //Falls in der App kein spezifischer Ort hinterlegt ist -> Aktuelle Position ermitteln
            ServiceManager.geoService.getCurrentPosition({ (position:Geoposition) -> Void in
                //TODO: Laden des Wetters falls gewünscht
                self.moveToPosition(position, name: "Current Location", weather: "")
                
                }) { (error:NSError) -> Void in
                    print(error)
                    //TODO: Info bez. Fehler bei Positionermittlung ausgeben
            }
        }
    }
    
    func moveToPosition(position: Geoposition, name: String, weather: String) {
        //Karte auf übergebene Position zentrieren
        let cllocation = CLLocation(latitude: position.lat, longitude: position.long)
        let region = MKCoordinateRegionMakeWithDistance(cllocation.coordinate, 500, 500)
        self.mapView.setRegion(region, animated: true)
        
        //Hinzufügen eines Markers
        self.mapView.addAnnotation(WeatherLocationMapOverlay(locationName: name, weatherName: weather, coordinate: position))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
}
