//
//  weatherTests.swift
//  weatherTests
//
//  Created by Joseph Grist on 10/12/21.
//

import XCTest
@testable import weather

class weatherTests: XCTestCase {

    let woeid = 1100661
    
    override func setUpWithError() throws {
        App.instance.testMode()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeWoeid() async throws {
        let result = try await App.instance.weatherManager.queryLocation()
        XCTAssertTrue(result == woeid)
    }
    
    func getWeather() async throws -> CurrentWeatherResponse {
        return try await App.instance.weatherManager.getCurrentWeather(for: woeid)
    }

    func testDecodeWeather() async throws {
        let weather = try await getWeather()
        XCTAssertTrue(weather.consolidated_weather.count > 0)
    }
    
    func testClearWeather() {
        App.instance.dataManager.clear()
        let entries = App.instance.dataManager.getEntries()
        let sources = App.instance.dataManager.getSources()
        XCTAssertTrue(entries.count == 0, "Entries count was: \(entries.count)")
        XCTAssertTrue(sources.count == 0, "Sources count was: \(sources.count)")
    }
    
    func testStoreData() async throws {
        let weather = try await getWeather()
        App.instance.weatherManager.save(weather: weather)
        let entries = App.instance.dataManager.getEntries()
        let sources = App.instance.dataManager.getSources()
        XCTAssertTrue(entries.count == 6, "Entries count was: \(entries.count)")
        XCTAssertTrue(sources.count == 7, "Sources count was: \(sources.count)")
    }
}
