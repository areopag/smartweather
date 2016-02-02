//
//  WeatherIcon.swift
//  smartWeather
//
//  Created by Florian on 14/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation
import UIKit

class WeatherIcon {
    var regEx: NSRegularExpression?
    var parts: [WeatherIconPart]
    
    init(regExStr: String, parts: [WeatherIconPart]) {
        self.parts = parts
        do {
            self.regEx = try NSRegularExpression(pattern: regExStr, options: [])
        }
        catch let error as NSError {
            print(error) //Wird nur statisch im Code erzeut -> Sollte nie auftreten
        }
    }
    
    class func getIconForWeatherCode(weatherCode: String) -> WeatherIcon? {
        for i in IconSet {
            if i.regEx?.firstMatchInString(weatherCode, options:[], range: NSRange(location: 0,length: weatherCode.characters.count)) != nil {
                return i
            }
        }
        return nil
    }
    
    static var IconSet = [
        WeatherIcon(regExStr: "2..", parts: [WeatherIconPart(iconChar: "\u{F114}", color: UIColor(red: 1.0, green: 0.647, blue: 0.0, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "3[01]0", parts: [WeatherIconPart(iconChar: "\u{F101}", color: UIColor(red: 1.0, green: 0.647, blue: 0.0, alpha: 1)), WeatherIconPart(iconChar: "\u{F10A}", color: UIColor(red: 0.51, green: 0.698, blue: 0.894, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "3[01][12]", parts: [WeatherIconPart(iconChar: "\u{F10A}", color: UIColor(red: 0.51, green: 0.698, blue: 0.894, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "31[34]|32.", parts: [WeatherIconPart(iconChar: "\u{F10E}", color: UIColor(red: 0.275, green: 0.506, blue: 0.765, alpha: 1)), WeatherIconPart(iconChar: "\u{F109}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "50[2-4]", parts: [WeatherIconPart(iconChar: "\u{F107}", color: UIColor(red: 0.275, green: 0.506, blue: 0.765, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "50[01]", parts: [WeatherIconPart(iconChar: "\u{F101}", color: UIColor(red: 1.0, green: 0.647, blue: 0.0, alpha: 1)), WeatherIconPart(iconChar: "\u{F107}", color: UIColor(red: 0.275, green: 0.506, blue: 0.765, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "51.", parts: [WeatherIconPart(iconChar: "\u{F10C}", color: UIColor(red: 0.675, green: 0.827, blue: 0.953, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "520", parts: [WeatherIconPart(iconChar: "\u{F101}", color: UIColor(red: 1.0, green: 0.647, blue: 0.0, alpha: 1)), WeatherIconPart(iconChar: "\u{F104}", color: UIColor(red: 0.275, green: 0.506, blue: 0.765, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "5[23][12]", parts: [WeatherIconPart(iconChar: "\u{F104}", color: UIColor(red: 0.275, green: 0.506, blue: 0.765, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "600", parts: [WeatherIconPart(iconChar: "\u{F101}", color: UIColor(red: 1.0, green: 0.647, blue: 0.0, alpha: 1)), WeatherIconPart(iconChar: "\u{F10B}", color: UIColor(red: 0.675, green: 0.827, blue: 0.953, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "60[12]", parts: [WeatherIconPart(iconChar: "\u{F10B}", color: UIColor(red: 0.675, green: 0.827, blue: 0.953, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "61[126]", parts: [WeatherIconPart(iconChar: "\u{F10C}", color: UIColor(red: 0.675, green: 0.827, blue: 0.953, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "615", parts: [WeatherIconPart(iconChar: "\u{F101}", color: UIColor(red: 1.0, green: 0.647, blue: 0.0, alpha: 1)), WeatherIconPart(iconChar: "\u{F10C}", color: UIColor(red: 0.675, green: 0.827, blue: 0.953, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "620", parts: [WeatherIconPart(iconChar: "\u{F101}", color: UIColor(red: 1.0, green: 0.647, blue: 0.0, alpha: 1)), WeatherIconPart(iconChar: "\u{F103}", color: UIColor(red: 0.675, green: 0.827, blue: 0.953, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "62[12]", parts: [WeatherIconPart(iconChar: "\u{F103}", color: UIColor(red: 0.675, green: 0.827, blue: 0.953, alpha: 1)), WeatherIconPart(iconChar: "\u{F109}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "7..", parts: [WeatherIconPart(iconChar: "\u{F108}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "800|904|951", parts: [WeatherIconPart(iconChar: "\u{F113}", color: UIColor(red: 1.0, green: 0.647, blue: 0.0, alpha: 1))]),
        WeatherIcon(regExStr: "80[123]", parts: [WeatherIconPart(iconChar: "\u{F101}", color: UIColor(red: 1.0, green: 0.647, blue: 0.0, alpha: 1)), WeatherIconPart(iconChar: "\u{F106}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "804", parts: [WeatherIconPart(iconChar: "\u{F106}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "90[0125]|95[2-9]|96.", parts: [WeatherIconPart(iconChar: "\u{F115}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))]),
        WeatherIcon(regExStr: "903", parts: [WeatherIconPart(iconChar: "\u{F102}", color: UIColor(red: 0.522, green: 0.847, blue: 0.969, alpha: 1)), WeatherIconPart(iconChar: "\u{F105}", color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))])
    ]
}