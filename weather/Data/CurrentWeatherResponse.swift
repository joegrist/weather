//
//  CurrentWeatherResponse.swift
//  weather
//
//  Created by Joseph Grist on 10/12/21.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    var consolidated_weather: [CurrentWeatherEntry]
    var sources: [CurrentWeatherSource]
}

struct CurrentWeatherEntry: Decodable {
    
    static let dateFormatter = DateFormatter()
    
    var id: Int
    var applicable_date: String
    var weather_state_name: String
    var weather_state_abbr: String
    var min_temp: Double
    var max_temp: Double
    var the_temp: Double
    var wind_direction: Double
    var wind_speed: Double
    
    var date: Date? {
        CurrentWeatherEntry.dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        return CurrentWeatherEntry.dateFormatter.date(from: applicable_date)
    }
}

struct CurrentWeatherSource: Decodable {
    var title: String
    var url: String
}
