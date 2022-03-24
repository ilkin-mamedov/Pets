import Foundation

struct CoinModel {
    var rate: Double
    var quote: String

    var rateString: String {
        return String(format: "1 BTC = %.2f \(quote)", rate)
    }
}
