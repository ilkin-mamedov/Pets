import Foundation

struct WeatherModel {
    let conditionId: Int
    let city: String
    let country: String
    let temperature: Double
    let description: String
    let feelslike: Double
    let sunrise: Int
    let sunset: Int
    
    var conditionName: String {
        switch conditionId {
            case 200...232:
                return "cloud.bolt.fill"
            case 300...321:
                return "cloud.drizzle.fill"
            case 500...531:
                return "cloud.rain.fill"
            case 600...622:
                return "cloud.snow.fill"
            case 701...781:
                return "cloud.fog.fill"
            case 800:
                return "sun.max.fill"
            case 801...804:
                return "cloud.fill"
            default:
                return "cloud.fill"
        }
    }
    
    var cityName: String {
        return "\(city), \(country)"
    }
    
    var temperatureString: String {
        return String(format: "%.1f°C", temperature)
    }
    
    var feelslikeString: String {
        return String(format: "%.1f°C", feelslike)
    }
}
