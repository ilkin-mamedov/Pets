import Foundation

protocol CoinManagerDelegate {
    func didUpdateWeather(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(_ error: Error)
}
