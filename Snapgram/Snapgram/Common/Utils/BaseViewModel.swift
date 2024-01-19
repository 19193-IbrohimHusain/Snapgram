import Foundation
import SystemConfiguration
import GoogleMaps
import RxSwift
import RxCocoa

enum StateLoading: Int {
    case notLoad
    case loading
    case finished
    case failed
}

class BaseViewModel {
    internal let bag: DisposeBag = DisposeBag()
    internal let geocoder = GMSGeocoder()
    internal var loadingState = BehaviorRelay<StateLoading>(value: .notLoad)
    internal var location = BehaviorRelay<String?>(value: nil)
    
    internal func getLocationNameFromCoordinates(lat: Double, lon: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        var address = ""
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self ] response, error in
            guard error == nil, let self = self, let result = response?.firstResult() else {
                print("Geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            guard let city = result.administrativeArea, let country = result.country else { return }
            address = "\(city), \(country)"
            self.location.accept(address)
        }
    }
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }
}
    

