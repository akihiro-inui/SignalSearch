//
//  AppDelegate.swift
//  SingalSearch
//
//  Created by Akihiro Inui on 08/05/2022.
//
import GooglePlaces
import GoogleMaps
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let googlePlaceApiKey:String = ProcessInfo.processInfo.environment["GOOGLE_PLACE_API_KEY"] ?? "undefined"
    let googleMapsApiKey:String = ProcessInfo.processInfo.environment["GOOGLE_MAPS_API_KEY"] ?? "undefined"

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure API key for GooglePlaces and GoogleMaps
        GMSPlacesClient.provideAPIKey(googlePlaceApiKey)
        GMSServices.provideAPIKey(googleMapsApiKey)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

