import Foundation

class ApiReal: ApiBase, Api {
    
    func locationSearch(term: String) async throws -> [LocationSearchResult]? {
        
        let endpoint = locationSearchEndpoint(query: term)
        
        guard let Url = URL(string: endpoint) else {
            App.instance.logger.log("Could not parse endpoint \(endpoint) into URL")
            throw ApiError(App.Error.General)
        }
        
        let request = URLRequest(url: Url)
        
        do {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                App.instance.logger.log("Could not load \(Url)")
                throw ApiError(App.Error.Api)
            }
            
            let decoder = LocationSearchResponseDecoder()
            
            guard let decodedResponse = try decoder.decode(from: data) else {
                App.instance.logger.log("Could not decode location search response")
                throw ApiError(App.Error.Api)
            }
            return decodedResponse
            
        } catch {
            App.instance.logger.log("Error fetching location woeid")
            App.instance.logger.log(error.localizedDescription)
        }
        
        throw ApiError(App.Error.Api)
    }
    
    func currentWeather(for woeid: Int) async throws -> CurrentWeatherResponse? {
        
        let endpoint = currentWeatherEndpoint(woeid: woeid)
        
        guard let Url = URL(string: endpoint) else {
            App.instance.logger.log("Could not parse endpoint \(endpoint) into URL")
            throw ApiError(App.Error.General)
        }
        
        let request = URLRequest(url: Url)
        
        do {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                App.instance.logger.log("Could not load \(Url)")
                throw ApiError(App.Error.Api)
            }
            
            let decoder = CurrentWeatherResponseDecoder()
            guard let decodedResponse = try decoder.decode(from: data) else {
                App.instance.logger.log("Could not decode current weather response")
                throw ApiError(App.Error.Api)
            }
            return decodedResponse
            
        } catch {
            App.instance.logger.log("Error fetching weather")
            App.instance.logger.log(error.localizedDescription)
        }
        
        throw ApiError(App.Error.Api)
    }
}
