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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Hotel"
        view.addSubview(mapView)
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


extension ViewController: ResultViewControllerDelegete{
    func didTapPlace(with coordinate: CLLocationCoordinate2D) {
        
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        
        // Remove existing map pin
        mapView.clear()
        
        // Add a map pin and zoom in
        let pin = GMSMarker()
        pin.position = coordinate
        pin.tracksViewChanges = true
        pin.map = mapView
        mapView.camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 12)

    }
    
    
}
