import Foundation
import CoreLocation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=5223df3c7e7a213598539c7211df9927&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString) 
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let city = decodedData.name
            let country = decodedData.sys.country
            let temp = decodedData.main.temp
            let desc = decodedData.weather[0].description
            let feelslike = decodedData.main.feels_like
            let sunrise = decodedData.sys.sunrise
            let sunset = decodedData.sys.sunset
            let weather = WeatherModel(conditionId: id, city: city, country: country, temperature: temp, description: desc, feelslike: feelslike, sunrise: sunrise, sunset: sunset)
            return weather
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
    
}
