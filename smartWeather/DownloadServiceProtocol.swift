//
//  DownloadServiceProtocol.swift
//  smartWeather
//
//  Created by Florian on 22/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation

protocol DownloadServiceProtocol {
    func load(URL: NSURL, successCallback: NSData -> Void, errorCallback: NSError -> Void)
}