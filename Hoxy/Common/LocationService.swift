//
//  LocationService.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/07.
//

import Foundation
import CoreLocation
import Firebase

protocol TownList {
    var towns: [String] { get }
    var locations: [CLLocation] { get }
}

struct LocationService {
//    static var currentLocation: CLLocation?
//    static var userLocation: CLLocation?
//
//    static var currentTown: String = ""
//    static var userTown: String = ""
    
    
    static func saveUserLocation(town: String, location: CLLocation) {
        UserDefaults.standard.set(town, forKey: Constants.userTown)
        UserDefaults.standard.set(location: location, forKey: Constants.userLocation)

        UserDefaults.standard.synchronize()
    }
    
    static func saveCurrentLocation(town: String, location: CLLocation) {
        UserDefaults.standard.set(town, forKey: Constants.currentTown)
        UserDefaults.standard.set(location: location, forKey: Constants.currentLocation)
           
        UserDefaults.standard.synchronize()
    }
    
    static func getTownData() -> [String] {
        let current = UserDefaults.standard.string(forKey: Constants.currentTown) ?? ""
        let user = UserDefaults.standard.string(forKey: Constants.userTown) ?? ""
        return [current, user]
    }
    
    static func getLocationData() -> [CLLocation?] {
        let currentLocation = UserDefaults.standard.location(forKey: Constants.currentLocation)
        let userLocation = UserDefaults.standard.location(forKey: Constants.userLocation)
        
        return [currentLocation, userLocation]
    }
    
    static func getGeoPoint(location: CLLocation) -> GeoPoint {
        return GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    static func currentLocation() -> CLLocation? {
        return UserDefaults.standard.location(forKey: Constants.currentLocation)
    }
    
    static func userLocation() -> CLLocation? {
        return UserDefaults.standard.location(forKey: Constants.userLocation)
    }
}

