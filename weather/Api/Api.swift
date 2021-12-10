import Foundation

protocol Api {
    func locationSearch(term: String) async throws -> [LocationSearchResult]?
    func currentWeather(for woeid: Int) async throws -> CurrentWeatherResponse?
}

class ApiBase {
    private static let host = "https://www.metaweather.com"
    private static let locationSearchEndpointBase = "/api/location/search/?query="
    private static let currentWeatherEndpointBase = "/api/location/"
    
    func locationSearchEndpoint(query: String) -> String {
        return "\(ApiBase.host)\(ApiBase.locationSearchEndpointBase)\(query)"
    }
    
    func currentWeatherEndpoint(woeid: Int) -> String {
        return "\(ApiBase.host)\(ApiBase.currentWeatherEndpointBase)\(woeid)/"
    }
}

struct ApiError: Error, LocalizedError {
    
    let error: App.Error
    
    init(_ error: App.Error) {
        self.error = error
    }
    
    public var errorDescription: String? {
        error.rawValue
    }
}
