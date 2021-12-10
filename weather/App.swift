//
//  App.swift
//  weather
//
//  Created by Joseph Grist on 10/12/21.
//

import Foundation

class App {
    
    static var instance = App()
    
    enum Error: String {
        case General = "System Error"
        case Api = "Could not communicate with server"
        case NoData = "Could not find any weather for your location"
    }
    
    static let newDataIsReady = NSNotification.Name("newDataIsReady")
    static let errorNotification = NSNotification.Name("errorNotification")
    static let errorNotificationMessageUserInfoKey = "errorNotificationMessageUserInfoKey"
    
    static let woeIdBrisbane = 1100661
    static let woeIdHobart = 1102670
    
    var api: Api = ApiReal()
    let logger = Logger()
    let manager = WeatherManager()
    
    func testMode() {
        api = ApiMock()
    }
}
