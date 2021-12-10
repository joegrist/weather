import Foundation

struct ManagerError: Error, LocalizedError {
    let error: App.Error
}

class WeatherManager {
    func post(error: App.Error, diagnostic: String) {
        NotificationCenter.default.post(name: App.errorNotification, object: nil, userInfo: [App.errorNotificationMessageUserInfoKey : error.rawValue])
        App.instance.logger.log(diagnostic)
    }
    
    func queryLocation() async throws -> Int {
        
        let locations = try await App.instance.api.locationSearch(term: "Brisbane")
        guard let location = locations?.first else {
            // TODO: Would need a UI to resolve
            post(error: .General, diagnostic: "Location not found")
            throw ManagerError(error: .NoData)
        }
        
        return location.woeid
    }
    
    func getCurrentWeather(for woeid: Int) async throws -> CurrentWeatherResponse {
        
        let weather = try await App.instance.api.currentWeather(for: woeid)
        
        guard let weather = weather else {
            post(error: .Api, diagnostic: "Fetching weather failed")
            throw ManagerError(error: .Api)
        }
        
        if weather.consolidated_weather.count == 0 {
            post(error: .NoData, diagnostic: "No weather was found")
        }
        
        return weather
    }
}
