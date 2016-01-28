//
//  DownloadServiceMock.swift
//  smartWeather
//
//  Created by Florian on 22/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation
@testable import smartWeather

class DownloadServiceMock : DownloadServiceProtocol {
    var preparedResults = Dictionary<String,String>()
    
    func load(URL: NSURL, successCallback: NSData -> Void, errorCallback: NSError -> Void) {
        let urlStr = URL.absoluteString
        for rslt in preparedResults {
            do {
                let regex = try NSRegularExpression(pattern: rslt.0, options: [])
                if  (regex.firstMatchInString(urlStr, options: [], range: NSRange(location: 0,length: urlStr.characters.count)) != nil) {
                    successCallback(rslt.1.dataUsingEncoding(NSUTF8StringEncoding)!)
                    return
                }
            } catch let ex as NSError {
                errorCallback(ex)
                return
            }
        }
        
        //if no prepared result given -> return empty (Error would be better)
        successCallback("".dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    func addPreparedResult(urlRegEx: String, result: String) {
        self.preparedResults[urlRegEx] = result
    }
}