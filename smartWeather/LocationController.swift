//
//  LocationController.swift
//  smartWeather
//
//  Created by Robs on 21/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//
//  Controller for the Location view
//

import UIKit
import EventKit

class LocationController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tvLocations: UITableView!
    @IBOutlet weak var sbSearch: UISearchBar!
    
    var locationsList: [locationTableItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewControllerDidLoad")
        
        tvLocations.delegate = self
        tvLocations.dataSource = self
        
        sbSearch.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        sbSearch.text = ""
        loadList()
    }
    
    func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            print("updateUI")
            self.tvLocations.reloadData()
        }
    }
    
    func loadList() {
        print("loadList")
        
        locationsList = []
        
        // add the current position
        let currentPosition = Location()
        locationsList.append(locationTableItem(name: "Current Position", details: "using GPS", location: currentPosition, type: locationTableItemType.Current))
        
        // add recent searched and clicked cities
        loadRecentCities()
        
        // refresh the UI list
        updateUI()
        
        // add/request locations from the calendar
        requestAccessToCalendar()
    }
    
    func loadRecentCities() {
        print("loadRecentCities")
        
        let recentCityIDs = ServiceManager.settingsService.getRecentCities()
        let recentCities = ServiceManager.databaseService.getLocationsForCityIDs(recentCityIDs)
        print(recentCities)
        for item in recentCities {
            print("recentLocation: \(item)")
            locationsList.append(locationTableItem(name: "\(item.name!) (\(item.country))", details: "Recent search result", location: item, type: locationTableItemType.Recent))
        }
    }
    
    func requestAccessToCalendar() {
        print("requestAccessToCalendar")
        
        EKEventStore().requestAccessToEntityType(EKEntityType.Event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadLocationsFromCalendar()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    // TODO
                })
            }
        })
    }
    
    func loadLocationsFromCalendar()
    {
        print("loadLocationsFromCalendar")
        
        do {
            let appointmentLocations = try ServiceManager.calendarService.getCalendarEntryLocations(7)
            
            for item in appointmentLocations {                
                locationsList.append(locationTableItem(name: "\(item.name!) (\(item.country))", details: "Appointment: \(item.details)", location: item, type: locationTableItemType.Appointment))
            }
            
            updateUI()
        } catch { // did not work without this catch
            //TODO: Notify user about the error...
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tvLocationsCell", forIndexPath: indexPath) as! locactionTableViewCell
                
        let row = locationsList[indexPath.row]
        
        cell.lblSubject.text = row.name
        cell.lblDetails.text = row.details
        cell.imgImage.contentMode = .Center        
        //cell.imgImage.contentScaleFactor = 0.6
        
        switch row.type {
        case locationTableItemType.Current:
            cell.imgImage.image = UIImage(named: "type_location")
        case locationTableItemType.Appointment:
            cell.imgImage.image = UIImage(named: "type_calendar")
        case locationTableItemType.Recent:
            cell.imgImage.image = UIImage(named: "type_search")
        case locationTableItemType.Search:
            cell.imgImage.image = UIImage(named: "type_search")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        print("cell clicked: \(locationsList[row])")
        
        if(locationsList[row].type != locationTableItemType.Current) {
            if (locationsList[row].type == locationTableItemType.Search) {
                // save clicked search item
                ServiceManager.settingsService.addRecentCity(locationsList[row].location.cityId!)
            }
            
            do {
                try ServiceManager.settingsService.setCurrentCityLocation(locationsList[row].location)
            } catch _ {
                print("cannot save location")
            }
        } else { // current location
            do {
                print("current location")
                try ServiceManager.settingsService.setCurrentCityLocation(nil)
            } catch _ {
                print("cannot save location")
            }
        }
        
        // goto main screen
        let tabController = self.view.window?.rootViewController as! UITabBarController
        tabController.selectedIndex = 0
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.characters.count >= 2) {
            search(searchText)
        } else {
            loadList()
        }
        
    }
    
    func search(needle: String) {
        
        let results = ServiceManager.databaseService.searchLocationsByNeedle(needle, maxResults: 20)
        print("Search result: \(results)")
        
        locationsList = []
        
        for item in results {
            print("searchResultLocation: \(item)")            
            locationsList.append(locationTableItem(name: "\(item.name!) (\(item.country))", details: "Search result", location: item, type: locationTableItemType.Search))
        }
        
        updateUI()
    }
    
    
}

class locactionTableViewCell : UITableViewCell {
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
}

class locationTableItem {
    var name: String
    var details: String
    var location: Location
    var type: locationTableItemType
    
    init(name: String, details: String, location: Location, type:locationTableItemType) {
        self.name = name
        self.details = details
        self.location = location
        self.type = type
    }
    
}

enum locationTableItemType {
    case Current
    case Recent
    case Appointment
    case Search
}
