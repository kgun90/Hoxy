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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func moveToHome() {
        let vc = TabBarController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
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
    
    func getLocationName() {
        let geocode = CLGeocoder()
        geocode.reverseGeocodeLocation(currentLocation) { (placemark, error) in
            guard
                let mark = placemark,
                let town = mark.first?.subLocality
            else {
                return
            }
            LocationService.currentTown = town
        
            if !LocationService.userTown.isEmpty {
                self.moveToHome()
            }
        }
    }
    
    func getUserLocation() {
        if let user = Auth.auth().currentUser?.uid {
            set.fs.collection(set.Table.member).document(user).addSnapshotListener {  (snapShot, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let data = snapShot?.data() {
                        let town = data["town"] as! String
                        let location = data["location"] as! GeoPoint
                        LocationService.userTown = town
                        LocationService.userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
    
                        if !LocationService.currentTown.isEmpty {
                            self.moveToHome()
                        }
                    }
                }
            }
        }
    }
    
    
}
extension LocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            currentLocation = location
            LocationService.currentLocation = location
            
            getLocationName()
            getUserLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
