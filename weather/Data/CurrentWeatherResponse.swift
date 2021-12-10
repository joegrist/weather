//
//  CurrentWeatherResponse.swift
//  weather
//
//  Created by Joseph Grist on 10/12/21.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    var consolidated_weather: [WeatherEntry]
    var sources: [WeatherSource]
}

struct WeatherEntry: Decodable {
    var id: Int
    var applicable_date: String
    var weather_state_name: String
    var weather_state_abbr: String
    var min_temp: Double
    var max_temp: Double
    var the_temp: Double
}

struct WeatherSource: Decodable {
    var title: String
    var url: String
}
