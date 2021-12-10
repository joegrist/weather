import Foundation

class ResponseDecoder {
    let decoder = JSONDecoder()
    func logDecoderError(_ error: DecodingError) {
        switch error {
        case let .keyNotFound(key, context):
            App.instance.logger.log("Key '\(key)' not found: \(context.debugDescription)")
        case let .typeMismatch(type, context):
            App.instance.logger.log("Type '\(type)' mismatch: \(context.debugDescription)")
        case let .valueNotFound(value, context):
            App.instance.logger.log("Value '\(value)' not found: \(context.debugDescription)")
        case let .dataCorrupted(context):
            App.instance.logger.log("JSON Error: \(context.debugDescription)")
        @unknown default:
            App.instance.logger.log("Unknown error decoding JSON")
        }
    }
}

class LocationSearchResponseDecoder: ResponseDecoder {
    
    func decode(from data: Data) throws -> [LocationSearchResult]? {

        do {
            return try decoder.decode([LocationSearchResult].self, from: data)
        } catch {
            if let error = error as? DecodingError {
                logDecoderError(error)
            }
            App.instance.logger.log("Could not decode location search response: \(error.localizedDescription)")
        }
        
        throw ApiError(App.Error.Api)
    }
}

class CurrentWeatherResponseDecoder: ResponseDecoder {
    
    func decode(from data: Data) throws -> CurrentWeatherResponse? {
                
        do {
            return try decoder.decode(CurrentWeatherResponse.self, from: data)
        } catch {
            if let error = error as? DecodingError {
                logDecoderError(error)
            }
            App.instance.logger.log("Could not decode weather info response: \(error.localizedDescription)")
        }
        
        throw ApiError(App.Error.Api)
    }
}
