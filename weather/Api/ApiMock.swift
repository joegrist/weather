import Foundation

class ApiMock: ApiBase, Api {

    let sampleLocationSearchResponse = """
[{"title":"Brisbane","location_type":"City","woeid":1100661,"latt_long":"-27.468880,153.022827"}]
"""
    
let sampleCurrentWeatherResponse = """
{"consolidated_weather":[{"id":5814458686373888,"weather_state_name":"Showers","weather_state_abbr":"s","wind_direction_compass":"NW","created":"2021-12-10T09:59:02.333357Z","applicable_date":"2021-12-10","min_temp":3.76,"max_temp":8.08,"the_temp":5.890000000000001,"wind_speed":10.037275985707469,"wind_direction":311.00101701768256,"air_pressure":998.0,"humidity":77,"visibility":10.786693211644,"predictability":73},{"id":5525692130263040,"weather_state_name":"Light Rain","weather_state_abbr":"lr","wind_direction_compass":"SW","created":"2021-12-10T09:59:02.537087Z","applicable_date":"2021-12-11","min_temp":2.275,"max_temp":10.129999999999999,"the_temp":6.0600000000000005,"wind_speed":4.801516056162677,"wind_direction":225.9875877789444,"air_pressure":1017.0,"humidity":80,"visibility":8.167924321959754,"predictability":75},{"id":6263815344750592,"weather_state_name":"Showers","weather_state_abbr":"s","wind_direction_compass":"SW","created":"2021-12-10T09:59:02.763714Z","applicable_date":"2021-12-12","min_temp":9.780000000000001,"max_temp":12.92,"the_temp":12.600000000000001,"wind_speed":6.6405878954108,"wind_direction":226.99510674900898,"air_pressure":1020.0,"humidity":89,"visibility":9.298198520639465,"predictability":73},{"id":5692379718746112,"weather_state_name":"Showers","weather_state_abbr":"s","wind_direction_compass":"SSW","created":"2021-12-10T09:59:02.758128Z","applicable_date":"2021-12-13","min_temp":9.015,"max_temp":12.08,"the_temp":11.73,"wind_speed":7.838736046180969,"wind_direction":206.48933374095546,"air_pressure":1021.5,"humidity":81,"visibility":9.70022568201702,"predictability":73},{"id":6021687477796864,"weather_state_name":"Heavy Cloud","weather_state_abbr":"hc","wind_direction_compass":"WSW","created":"2021-12-10T09:59:01.866808Z","applicable_date":"2021-12-14","min_temp":7.65,"max_temp":11.265,"the_temp":10.985,"wind_speed":5.889902130684802,"wind_direction":242.56475140136232,"air_pressure":1022.5,"humidity":84,"visibility":12.106485623956097,"predictability":71},{"id":4547601618698240,"weather_state_name":"Light Cloud","weather_state_abbr":"lc","wind_direction_compass":"WSW","created":"2021-12-10T09:59:05.159690Z","applicable_date":"2021-12-15","min_temp":8.455,"max_temp":11.86,"the_temp":9.93,"wind_speed":4.489444046766881,"wind_direction":238.0,"air_pressure":1029.0,"humidity":82,"visibility":9.999726596675416,"predictability":70}],"time":"2021-12-10T11:30:36.374185Z","sun_rise":"2021-12-10T07:55:06.358756Z","sun_set":"2021-12-10T15:51:28.637440Z","timezone_name":"LMT","parent":{"title":"England","location_type":"Region / State / Province","woeid":24554868,"latt_long":"52.883560,-1.974060"},"sources":[{"title":"BBC","slug":"bbc","url":"http://www.bbc.co.uk/weather/","crawl_rate":360},{"title":"Forecast.io","slug":"forecast-io","url":"http://forecast.io/","crawl_rate":480},{"title":"HAMweather","slug":"hamweather","url":"http://www.hamweather.com/","crawl_rate":360},{"title":"Met Office","slug":"met-office","url":"http://www.metoffice.gov.uk/","crawl_rate":180},{"title":"OpenWeatherMap","slug":"openweathermap","url":"http://openweathermap.org/","crawl_rate":360},{"title":"Weather Underground","slug":"wunderground","url":"https://www.wunderground.com/?apiref=fc30dc3cd224e19b","crawl_rate":720},{"title":"World Weather Online","slug":"world-weather-online","url":"http://www.worldweatheronline.com/","crawl_rate":360}],"title":"London","location_type":"City","woeid":44418,"latt_long":"51.506321,-0.12714","timezone":"Europe/London"}
"""
    
    func locationSearch(term: String) async throws -> [LocationSearchResult]? {
        let decoder = LocationSearchResponseDecoder()
        return try decoder.decode(from:sampleLocationSearchResponse.data(using: .utf8)!)
    }
    
    func currentWeather(for: Int) async throws -> CurrentWeatherResponse? {
        let decoder = CurrentWeatherResponseDecoder()
        return try decoder.decode(from: sampleCurrentWeatherResponse.data(using: .utf8)!)
    }
    
}

