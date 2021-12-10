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
        let result = try await App.instance.manager.queryLocation()
        XCTAssertTrue(result == woeid)
    }

    func testDecodeWeather() async throws {
        let weather = try await App.instance.manager.getCurrentWeather(for: woeid)
        XCTAssertTrue(weather.consolidated_weather.count > 0)
    }
}
