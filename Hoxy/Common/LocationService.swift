//
//  LocationService.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/07.
//

import Foundation
import CoreLocation

protocol TownList {
    var towns: [String] { get }
    var locations: [CLLocation] { get }
}

struct LocationService {
    static var currentLocation: CLLocation?
    static var userLocation: CLLocation?

    
    static var currentTown: String = ""
    static var userTown: String = ""
    
    var towns: [String] {
        if LocationService.currentTown.isEmpty == false && LocationService.userTown.isEmpty == false {
            return [LocationService.currentTown, LocationService.userTown]
        }
        return []
    }
    
    var locations: [CLLocation] {
        if LocationService.currentLocation != nil && LocationService.userLocation != nil {
            return [LocationService.currentLocation!, LocationService.userLocation!]
        }
        return []
    }
    
}
