//
//  DatabaseService.swift
//  smartWeather
//
//  Created by Florian on 07/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseService:DatabaseServiceProtocol {
    func getLocationFromCityName(location: String) -> Location? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "City")
        fetchRequest.predicate = NSPredicate(format: "name = %@", location)
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let citiesRaw = results as! [NSManagedObject]
            print("cities queried: \(citiesRaw.count)")
            if citiesRaw.count > 0 {
                let c = citiesRaw[0]
                let values = c.committedValuesForKeys(["id","name","lat","long"])
                let position = Geoposition(lat:values["lat"] as! Double, long: values["long"] as! Double)
                let location = Location(position: position)
                location.name = values["name"] as? String
                location.cityId = values ["id"] as? Int
                return location
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        return nil
    }
    
    
    func getLocationsForCityIDs(cityIDs: [Int]) -> [Location] {
        var locations = [Location]()
        
        if cityIDs.count == 0 {
            return locations
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "City")
        var whereClause = [NSPredicate]()
        for cityID in cityIDs {
            whereClause.append(NSPredicate(format:"id = %d", cityID))
        }
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: whereClause)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let citiesRaw = results as! [NSManagedObject]
            print("cities queried: \(citiesRaw.count)")
            for row in citiesRaw {
                let values = row.committedValuesForKeys(["id","name","lat","long"])
                let position = Geoposition(lat:values["lat"] as! Double, long: values["long"] as! Double)
                let location = Location(position: position)
                location.name = values["name"] as? String
                location.cityId = values ["id"] as? Int
                locations.append(location)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return locations
    }
    
    func searchLocationsByNeedle(needle: String, maxResults: Int) -> [Location] {
        var locations = [Location]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "City")
        var whereClause = [NSPredicate]()
        
        whereClause.append(NSPredicate(format:"name BEGINSWITH[c] %@", needle))
        
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: whereClause)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.fetchLimit = maxResults
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let citiesRaw = results as! [NSManagedObject]
            print("cities queried: \(citiesRaw.count)")
            for row in citiesRaw {
                let values = row.committedValuesForKeys(["id","name","lat","long"])
                let position = Geoposition(lat:values["lat"] as! Double, long: values["long"] as! Double)
                let location = Location(position: position)
                location.name = values["name"] as? String
                location.cityId = values ["id"] as? Int
                locations.append(location)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return locations
    }
    
    func readCitiesList() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "City")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cities = results as! [NSManagedObject]
            print(cities.count)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func updateCitiesList() {
        var batchCounter : Int = 0
        
        if let path = NSBundle.mainBundle().pathForResource("city.list" , ofType: "json") {
            print("read from \(path)")
            if let jsonData = NSData(contentsOfFile: path) {
                let json = JSON(data: jsonData)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                for c in json.array! {
                    let entity =  NSEntityDescription.entityForName("City",
                        inManagedObjectContext:managedContext)
                    let city = NSManagedObject(entity: entity!,
                        insertIntoManagedObjectContext: managedContext)
                    
                    city.setValue(c["_id"].int, forKey: "id")
                    city.setValue(c["name"].string, forKey: "name")
                    city.setValue(c["country"].string, forKey: "country")
                    city.setValue(c["coord"]["lat"].double, forKey: "lat")
                    city.setValue(c["coord"]["lon"].double, forKey: "long")
                    
                    // save after 500 entries for preventing memory issues
                    batchCounter++
                    if(batchCounter >= 500) {
                        print("batch written...")
                        do {
                            try managedContext.save()
                        } catch let error as NSError  {
                            print("Could not save \(error), \(error.userInfo)")
                        }
                        managedContext.reset()
                        batchCounter = 0
                    }
                }
                
                // save the rest
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
    }

}