import UIKit
import FloatingPanel
import GoogleMaps
import Security
import RxSwift

class BaseViewController: UIViewController, CLLocationManagerDelegate {
    internal let cvc = CommentViewController()
    internal let pickerImage = UIImagePickerController()
    internal let activityIndicator = UIActivityIndicatorView(style: .medium)
    internal let locationManager = CLLocationManager()
    internal let geocoder = GMSGeocoder()
    internal let bag = DisposeBag()
    internal let refreshControl = UIRefreshControl()
    internal var errorView: CustomErrorView!
    internal let marker = GMSMarker()
    internal let map = GMSMapView()
    internal var bounds = GMSCoordinateBounds()
    internal var latitude = Double()
    internal var longitude = Double()
    
    internal func setupNavigationBar(title: String, image1: String, image2: String, action1: Selector?, action2: Selector?) {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: configureNavigationTitle(title: title)), animated: false)
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: image1), style: .plain, target: self, action: action1),
            UIBarButtonItem(image: UIImage(systemName: image2), style: .plain, target: self, action: action2)
        ]
    }
    
    internal func configureNavigationTitle(title: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        let spacer = UIView()
        let constraint = spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: .greatestFiniteMagnitude)
        constraint.isActive = true
        constraint.priority = .defaultLow
        let stack = UIStackView(arrangedSubviews: [titleLabel, spacer])
        stack.axis = .horizontal
        return stack
    }
    
    internal func setupErrorView() {
        self.errorView = CustomErrorView(frame: view.frame)
    }
    
    internal func validateInputField(_ inputField: CustomInputField, title: String, message: String, completion: @escaping () -> Void) -> Bool {
        guard let text = inputField.textField.text, !text.isEmpty else {
            displayAlert(title: title, message: message, completion:  {
                completion()
            })
            return false
        }
        return true
    }
    
    
    internal func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    internal func validatePassword(candidate: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: candidate)
    }
    
    internal func displayAlert(title: String, message: String, action: (() -> UIAlertAction)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        if let anotherAction = action {
            alertController.addAction(anotherAction())
        }
        present(alertController, animated: true, completion: nil)
    }
    
    internal func addLoading(_ button: UIButton) {
        button.isEnabled = false
        button.isUserInteractionEnabled = false
        button.layer.backgroundColor = UIColor.systemGray5.cgColor
        activityIndicator.center = CGPoint(x: button.bounds.width / 2 , y: button.bounds.height / 2)
        button.addSubview(activityIndicator)
        button.setTitle("", for: .disabled)
        activityIndicator.startAnimating()
    }
    
    internal func afterDissmissed(_ button: UIButton, title: String) {
        activityIndicator.stopAnimating()
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.layer.backgroundColor = UIColor.systemBlue.cgColor
        button.setTitle(title, for: .normal)
    }
    
    internal func getLocationNameFromCoordinates(lat: Double, lon: Double, completion: @escaping (String) -> Void) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard error == nil, let result = response?.firstResult() else {
                print("Geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            guard let city = result.administrativeArea, let country = result.country else { return }
            let address = "\(city), \(country)"
            completion(address)
        }
    }
    
    internal func getAddressFromCurrentLocation(lat: Double, lon: Double, completion: @escaping (String?) -> Void) {
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard error == nil, let result = response?.firstResult() else {
                print("Geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let name = result.lines?.joined(separator: "")
            completion(name)
        }
    }
    
    internal func navigateToDetailStory() {
        
    }
        
    internal func storeToken(with token: String) {
        // Prepare the data to be stored (your authentication token)
        let tokenData = token.data(using: .utf8)
        
        // Create a dictionary to specify the keychain item attributes
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "AuthToken",
            kSecValueData: tokenData!,
        ]
        
        // Add the item to the keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Token saved to Keychain")
        } else {
            print("Failed to save token to Keychain")
        }
    }
    
    internal func isTokenExistInKeychain() -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "AuthToken",
            kSecReturnData: kCFBooleanTrue as Any,
        ]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        
        return status == errSecSuccess ? true : false
    }
    
    internal func deleteToken() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "AuthToken",
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Token deleted from Keychain")
        } else {
            print("Failed to delete token from Keychain")
        }
    }
    
    internal func checkLocationAuthorization(_ map: GMSMapView) {
        switch locationManager.authorizationStatus {
        case .authorized, .authorizedWhenInUse, .authorizedAlways:
            map.isMyLocationEnabled = true
            map.settings.myLocationButton = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
        case .denied, .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    internal func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        checkLocationAuthorization(map)
    }
    
    internal func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else {
                return
            }
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            map.camera = GMSCameraPosition(
                target: location.coordinate,
                zoom: 15,
                bearing: 0,
                viewingAngle: 0)
        }
    
    internal func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print(error)
    }
}

extension BaseViewController: FloatingPanelControllerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return CustomFloatingPanelLayout()
    }
    
    func floatingPanel(_ fpc: FloatingPanelController, animatorForPresentingTo state: FloatingPanelState) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: TimeInterval(0.16), curve: .easeOut)
    }
    
    func floatingPanel(_ fpc: FloatingPanelController, animatorForDismissingWith velocity: CGVector) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: TimeInterval(0.16), curve: .easeOut)
    }
}
