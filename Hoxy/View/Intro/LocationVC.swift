//
//  LocationVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/07.
//

import UIKit
import Firebase
import CoreLocation

class LocationVC: BaseViewController {
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        view.backgroundColor = .white
        getCurrentLocation()
    }

    func getCurrentLocation() {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestLocation()
        }
    }
    
//    func getLocationName() {
//        let geocode = CLGeocoder()
//        geocode.reverseGeocodeLocation(currentLocation) { (placemark, error) in
//            guard
//                let mark = placemark,
//                let town = mark.first?.subLocality
//            else {
//                return
//            }
//            LocationService.currentTown = town
//
//            if !LocationService.userTown.isEmpty {
//                self.moveToRoot(TabBarController())
//            }
//        }
//    }
//
//    func getUserLocation() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        UserDataManager.getUserData(byID: uid) { data in
//            LocationService.userTown = data.town
//            guard let location = data.location else { return }
//            LocationService.userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//
//            if !LocationService.currentTown.isEmpty {
//                self.moveToRoot(TabBarController())
//            }
//        }
//    }
//
    
}
extension LocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            currentLocation = location
//            LocationService.currentLocation = location
            
//            getLocationName()
//            getUserLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
