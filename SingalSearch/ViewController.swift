//
//  ViewController.swift
//  SingalSearch
//
//  Created by Akihiro Inui on 08/05/2022.
//

import UIKit
import GoogleMaps
import MapKit

class ViewController: UIViewController, UISearchResultsUpdating {
    let mapView = GMSMapView()
    let searchVC = UISearchController(searchResultsController: ResultViewController())
    var locationManager = CLLocationManager()
    // Navigate to current location

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Hotel"
        
        // Current location button
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true

        // User Location
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Add Map as subview
        self.view.addSubview(mapView)
        self.view.bringSubviewToFront(mapView)
        view.addSubview(mapView)
        
        // Search Bar
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(
            x: 0,
            y:view.safeAreaInsets.top,
            width: view.frame.size.width,
            height: view.frame.size.height - view.safeAreaInsets.top
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last

        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                                          longitude: userLocation!.coordinate.latitude, zoom: 17.0)
        self.mapView.animate(to: camera)

        locationManager.stopUpdatingLocation()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? ResultViewController
        else {
                  return
              }
        
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query) {
            result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async{
                    resultsVC.update(with: places)
                }
            case .failure(let error):
                print(error)
            }
    }
    }
    
}

//
//func loadMarkersFromDB() {
//        let ref = FIRDatabase.database().reference().child("spots")
//        ref.observe(.childAdded, with: { (snapshot) in
//            if snapshot.value as? [String : AnyObject] != nil {
//                self.gMapView.clear()
//                guard let spot = snapshot.value as? [String : AnyObject] else {
//                    return
//                }
//                // Get coordinate values from DB
//                let latitude = spot["latitude"]
//                let longitude = spot["longitude"]
//
//                DispatchQueue.main.async(execute: {
//                    let marker = GMSMarker()
//                    // Assign custom image for each marker
//                    let markerImage = self.resizeImage(image: UIImage.init(named: "ParkSpaceLogo")!, newWidth: 30).withRenderingMode(.alwaysTemplate)
//                    let markerView = UIImageView(image: markerImage)
//                    // Customize color of marker here:
//                    markerView.tintColor = rented ? .lightGray : UIColor(hexString: "19E698")
//                    marker.iconView = markerView
//                    marker.position = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
//                    marker.map = self.gMapView
//                    // *IMPORTANT* Assign all the spots data to the marker's userData property
//                    marker.userData = spot
//                })
//            }
//        }, withCancel: nil)
//    }
//}

func loadNiB() -> MapMarkerWindow {
    let infoWindow = MapMarkerWindow.instanceFromNib() as! MapMarkerWindow
    return infoWindow
}

extension ViewController: ResultViewControllerDelegete{
    func didTapPlace(with coordinate: CLLocationCoordinate2D) {
        
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        
        // Remove existing map pin
        mapView.clear()
        
        // Add a map marker
        let marker = GMSMarker()
        marker.position = coordinate
        marker.tracksViewChanges = true
        marker.map = mapView
        marker.title = "Test title"
        marker.snippet = "Test Snippet"
        marker.tracksInfoWindowChanges = true
        
        // Zoom in to marker
        mapView.camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 12)

        // Add info view
        var markerData : NSDictionary?
        if let data = marker.userData! as? NSDictionary {
            markerData = data
        }
        let infoWindow = loadNiB()
        
        infoWindow.spotData = markerData
        // Configure UI properties of info window
        infoWindow.alpha = 0.9
        infoWindow.layer.cornerRadius = 12
        infoWindow.layer.borderWidth = 2
        infoWindow.layer.borderColor = UIColor(named: "19E698")?.cgColor
        infoWindow.infoButton.layer.cornerRadius = infoWindow.infoButton.frame.height / 2
        self.view.addSubview(infoWindow)
        
    }
    
    
}
