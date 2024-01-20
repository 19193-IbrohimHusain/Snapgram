import UIKit
import GoogleMaps
import RxSwift
import RxCocoa

class MapViewController: BaseViewController {
    
    @IBOutlet private weak var mapView: GMSMapView!
    
    private let vm = MapViewModel()
    private var dataMarker: [ListStory] = []
    private var listMarker: [GMSMarker] = []
    private let infoView = CustomViewMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationAuthorization(mapView)
        vm.fetchLocationStory(param: StoryParam(size: 30, location: 1))
    }
    
    private func setup() {
        self.navigationController?.navigationBar.tintColor = .label
        mapView.delegate = self
        locationManager.delegate = self
        infoView.delegate = self
    }
    
    private func bindData() {
        vm.mapData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self, let data = data?.listStory else { return }
            self.dataMarker.append(contentsOf: data)
            self.updateMapMarkers()
        }).disposed(by: bag)
    }
    
    private func updateMapMarkers() {
        DispatchQueue.main.async {
            self.dataMarker.forEach { item in
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: item.lat!, longitude: item.lon!)
                marker.title = item.name
                marker.snippet = item.description
                marker.userData = item
                marker.map = self.mapView
                marker.tracksInfoWindowChanges = true
                self.listMarker.append(marker)
                self.bounds = self.bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(self.bounds, with: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0))
            self.mapView.animate(with: update)
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return infoView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let point = mapView.projection.point(for: marker.position)
        let camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 10.0)
        mapView.animate(to: camera)
        
        if mapView.camera.zoom == 10.0 {
            showInfoView(marker: marker, at: point)
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoView.removeFromSuperview()
    }
    
    // Function for centering infoView of marker
    //    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    //        infoView.center = mapView.projection.point(for: marker.position)
    //        infoView.center.y = infoView.center.y - 100
    //    }
    
    private func showInfoView(marker: GMSMarker, at point: CGPoint) {
        let width = 200.0
        let height = 300.0
        let offset: CGFloat = 35
        
        let offsetX = point.x - (width * 0.5)
        let offsetY = point.y - height - offset
        
        infoView.frame = CGRect(x: offsetX, y: offsetY, width: width, height: height)
        infoView.layer.backgroundColor = UIColor.white.cgColor
        infoView.layer.cornerRadius = 20.0
        infoView.clipsToBounds = true
        if let infoData = marker.userData as? ListStory,
           let lat = infoData.lat,
           let lon = infoData.lon {
            getLocationNameFromCoordinates(lat: lat, lon: lon) { name in
                self.infoView.configure(id: infoData.id, name: infoData.name, location: name, image: infoData.photoURL, caption: infoData.description, createdAt: infoData.createdAt)
                self.infoView.locationLabel.isHidden = false
            }
        }
        mapView.addSubview(infoView)
    }
}

extension MapViewController: CustomViewMarkerDelegate {
    func navigateTo(id: String) {
        let vc = DetailStoryViewController()
        vc.storyID = id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        infoView.removeFromSuperview()
    }
}
