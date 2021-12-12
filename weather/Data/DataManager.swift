import UIKit
import CoreData

class DataManager {
    
    let weatherEntityName = "CurrentWeather"
    let sourceEntityName = "CurrentSource"
    
    func add(weather: CurrentWeatherEntry) {
        let new = NSEntityDescription.insertNewObject(forEntityName: weatherEntityName, into: persistentContainer.viewContext) as! CurrentWeather
        new.maxTemp = weather.max_temp
        new.minTemp = weather.min_temp
        new.temp = weather.the_temp
        new.date = weather.date
        new.stateName = weather.weather_state_name
        new.stateAbbr = weather.weather_state_abbr
        new.windDirection = weather.wind_direction
        new.windSpeed = weather.wind_speed
        new.uuid = UUID()
    }
    
    func add(source: CurrentWeatherSource) {
        let new = NSEntityDescription.insertNewObject(forEntityName: sourceEntityName, into: persistentContainer.viewContext) as! CurrentSource
        new.title = source.title
        new.url = URL(string: source.url)
        new.uuid = UUID()
    }
    
    func clear() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: weatherEntityName)
        let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)

        do {
            try persistentContainer.viewContext.execute(deleteRequest1)
        } catch let error as NSError {
            App.instance.logger.log("Could not clear all old weather: \(error.localizedDescription)")
        }
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: sourceEntityName)
        let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)

        do {
            try persistentContainer.viewContext.execute(deleteRequest2)
        } catch let error as NSError {
            App.instance.logger.log("Could not clear all old sources: \(error.localizedDescription)")
        }
    }
    
    func getEntries() -> [CurrentWeather] {
        let fetch = NSFetchRequest<NSDictionary>(entityName: weatherEntityName)
        fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            return try persistentContainer.viewContext.fetch(fetch) as! [CurrentWeather]
        } catch let error as NSError {
            App.instance.logger.log("Could not load weather: \(error.localizedDescription)")
        }
        return []
    }
    
    func getSources() -> [CurrentSource] {
        let fetch = NSFetchRequest<NSDictionary>(entityName: sourceEntityName)
        do {
            return try persistentContainer.viewContext.fetch(fetch) as! [CurrentSource]
        } catch let error as NSError {
            App.instance.logger.log("Could not load sources: \(error.localizedDescription)")
        }
        return []
    }
    
    private func makeUUIDPredicate(id: UUID) -> NSPredicate {
        return NSPredicate(format: "uuid == %@", id as CVarArg)
    }
    
    func getEntry(uuid: UUID) -> CurrentWeather? {
        do {
            let fetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: weatherEntityName)
            fetch.predicate = makeUUIDPredicate(id: uuid)
            fetch.fetchLimit = 1
            let entries = try persistentContainer.viewContext.fetch(fetch) as! [CurrentWeather]
            return entries.first
        } catch {
            App.instance.logger.log("Could not load forecast: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getSource(uuid: UUID) -> CurrentSource? {
        do {
            let fetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: sourceEntityName)
            fetch.predicate = makeUUIDPredicate(id: uuid)
            fetch.fetchLimit = 1
            let entries = try persistentContainer.viewContext.fetch(fetch) as! [CurrentSource]
            return entries.first
        } catch {
            App.instance.logger.log("Could not load source: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
