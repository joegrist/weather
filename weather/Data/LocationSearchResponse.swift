//
//  LocationSearchResponse.swift
//  weather
//
//  Created by Joseph Grist on 10/12/21.
//

import Foundation

struct LocationSearchResult: Decodable {
    var title: String
    var location_type: String
    var woeid: Int
    var latt_long: String
}
