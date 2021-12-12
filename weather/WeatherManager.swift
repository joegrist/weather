import UIKit

struct ManagerError: Error, LocalizedError {
    let error: App.Error
}

class WeatherManager {
    
    static let location = "Brisbane"
    
    func post(title: String? = nil, message: String, type: App.MessageType, diagnostic: String? = nil) {
        
        let realTitle: String
        if let title = title {
            realTitle = title
        } else {
            realTitle = type == .Error ? "Error" : "Done"
        }
        
        let userInfo: [String : Any] = [
            App.notificationMessageUserInfoKey : message,
            App.notificationTypeUserInfoKey : type.rawValue,
            App.notificationTitleUserInfoKey: realTitle
        ]
        
        NotificationCenter.default.post(name: App.messageNotification, object: nil, userInfo: userInfo)
        
        if let diagnostic = diagnostic {
            App.instance.logger.log(diagnostic)
        }
    }
    
    
    func refresh() async {
        
        NotificationCenter.default.post(name: App.newDataRequested, object: nil)
        
        var woeid: Int
        var weather: CurrentWeatherResponse
        
        do {
            woeid = try await queryLocation()
        } catch {
            post(message: App.Error.Api.rawValue, type: .Error, diagnostic: "Fetching weather failed")
            return
        }

        do {
            weather = try await getCurrentWeather(for: woeid)
        } catch {
            post(message: App.Error.NoData.rawValue, type: .Error, diagnostic: "No weather was found")
            return
        }
        
        App.instance.dataManager.clear()
        
        save(weather: weather)
        
        post(title: "You're up to date!",  message: "Got latest weather for \(WeatherManager.location)", type: .Success)
        NotificationCenter.default.post(name: App.newDataIsReady, object: nil)
    }
    
    func queryLocation() async throws -> Int {
        
        let locations = try await App.instance.api.locationSearch(term: WeatherManager.location)
        guard let location = locations?.first else {
            // TODO: Would need a UI to resolve
            throw ManagerError(error: App.Error.NoData)
        }
        
        return location.woeid
    }
    
    func getCurrentWeather(for woeid: Int) async throws -> CurrentWeatherResponse {
        
        let weather = try await App.instance.api.currentWeather(for: woeid)
        
        guard let weather = weather else {
            throw ManagerError(error: .Api)
        }
        
        return weather
    }
    
    func save(weather: CurrentWeatherResponse) {
        for entry in weather.consolidated_weather {
            App.instance.dataManager.add(weather: entry)
        }
        
        for source in weather.sources {
            App.instance.dataManager.add(source: source)
        }
        
        App.instance.dataManager.saveContext()
    }
    
    func makeSnapshot() -> NSDiffableDataSourceSnapshot<Int, UUID> {
        
        let weather = App.instance.dataManager.getEntries()
        let sources = App.instance.dataManager.getSources()
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        let sectionNumbers = [Int](0...SectionLayoutKind.allCases.count - 1)
                
        let entryUuids = weather.compactMap{ $0.uuid }
        let sourcesUuids = sources.compactMap{ $0.uuid }
        
        snapshot.appendSections(sectionNumbers)
        
        for section in SectionLayoutKind.allCases {
            switch section {
            case .Today:
                if entryUuids.indices.contains(0) {
                    let uuid = entryUuids.first!
                    // print("Appending \(uuid) to Today")
                    snapshot.appendItems([uuid], toSection: section.rawValue)
                }
            case .UpcomingDays:
                if entryUuids.count > 1 {
                    let upcomingUuids = [UUID](entryUuids[1...entryUuids.count - 1])
                    // print("Appending \(upcomingUuids) to Upcoming")
                    snapshot.appendItems(upcomingUuids, toSection: section.rawValue)
                }
            case .Sources:
                // print("Appending \(sourcesUuids) to Sources")
                snapshot.appendItems(sourcesUuids, toSection: section.rawValue)
            }
            
        }
        
        return snapshot
    }
}
