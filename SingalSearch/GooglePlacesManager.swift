//
//  GooglePlacesManager.swift
//  SingalSearch
//
//  Created by Akihiro Inui on 10/05/2022.
//

import Foundation
import CoreLocation
import GooglePlaces

struct Place {
    let name: String
    let identifier: String
}

enum PlacesError: Error {
    case failToFind
    case failToGetCoordinate
}


final class GooglePlacesManager {
    static let shared = GooglePlacesManager()
    
    private let client = GMSPlacesClient.shared()
    
    private init(
    ) {}
    
    public func findPlaces(query: String, completion: @escaping (Result<[Place], Error>) -> Void){
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        client.findAutocompletePredictions(fromQuery: query,
                                           filter: filter,
                                           sessionToken: nil){
            results, error in guard let results = results, error == nil else {
                completion(.failure(PlacesError.failToFind))
                return
            }
            
            let places: [Place] = results.compactMap({
                Place(name: $0.attributedFullText.string,
                      identifier: $0.placeID)
            })
            completion(.success(places))
        }
    }
    
    public func resolveLocation(for place: Place, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void
    ){
        client.fetchPlace(fromPlaceID: place.identifier, placeFields: .coordinate, sessionToken: nil) {
            googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.failToGetCoordinate))
                return
            }
        let coordinate = CLLocationCoordinate2D(
            latitude: googlePlace.coordinate.latitude,
            longitude: googlePlace.coordinate.longitude
        )
        
        completion(.success(coordinate))
        }
    }
}
