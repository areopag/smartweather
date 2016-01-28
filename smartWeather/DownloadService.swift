//
//  DownloadService.swift
//  smartWeather
//
//  Created by Florian on 19/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

class DownloadService : DownloadServiceProtocol {
    func load(URL: NSURL, successCallback: NSData -> Void, errorCallback: NSError -> Void) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                print("Success: \(statusCode)")
                
                // This is your file-variable:
                successCallback(data!)
            }
            else {
                // Failure
                print("Faulure: %@", error!.localizedDescription);
                errorCallback(error!)
            }
        })
        task.resume()
    }
}