//
//  CurrentWeather+CoreDataClass.swift
//  weather
//
//  Created by Joseph Grist on 12/12/21.
//
//

import Foundation
import CoreData
import UIKit

@objc(CurrentWeather)
public class CurrentWeather: NSManagedObject {

    func format(temp: Double) -> String {
        return "\(Int(round(temp)))℃"
    }
    
    var tempFormatted: String {
        return format(temp: temp)
    }
    
    var maxTempFormatted: String {
        return format(temp: maxTemp)
    }
    
    var minTempFormatted: String {
        return format(temp: minTemp)
    }
    
    var windSpeedFormatted: String {
        return "\(Int(round(windSpeed)))mph"
    }
    
    var icon: UIImage? {
        
        let name: String
        let colours: [UIColor]
        let chillyColours: [UIColor] = [.systemGray, .systemCyan]
        
        switch stateAbbr {
        case "sn":
            name = "cloud.snow"
            colours = chillyColours
            break
        case "sleet":
            name = "cloud.sleet"
            colours = chillyColours
        case "h":
            name = "cloud.hail"
            colours = chillyColours
        case "t":
            name = "cloud.bolt"
            colours = [.systemGray, .systemYellow]
        case "hr":
            name = "cloud.heavyrain"
            colours = chillyColours
        case "lr":
            name = "cloud.rain"
            colours = chillyColours
        case "s":
            name = "cloud.sun.rain"
            colours = [.systemGray, .systemYellow, .systemCyan]
        case "hc":
            name = "cloud"
            colours = chillyColours
        case "lc":
            name = "cloud.sun"
            colours = [.systemGray, .systemYellow]
        case "c":
            name = "sun.max"
            colours = [.systemYellow]
        default:
            return nil
        }
        
        let config = UIImage.SymbolConfiguration(paletteColors: colours)
        return UIImage(systemName: name )!.applyingSymbolConfiguration(config)!
    }
}
