//
//  LocationManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/30.
//

import Foundation
import CoreLocation

//@objc
public class LocationManager: NSObject, CLLocationManagerDelegate {
    
    public var latestLocation: CLLocation?
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        return locationManager
    }()
    
    private var enable = false
    
    public func startUpdatingLocation() {
        self.enable = true
        self.locationManager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        self.enable = false
        self.locationManager.stopUpdatingLocation()
    }
    
    public func getLocation() -> CLLocation? {
        guard let location = self.latestLocation else { return nil}
       
        return location
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.latestLocation = locations.sorted { $0.horizontalAccuracy < $1.horizontalAccuracy }.first
        if let location = locations.last {
            self.latestLocation = location
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            if self.enable {
                self.locationManager.startUpdatingLocation()
            }
        default:
            self.locationManager.stopUpdatingLocation()
        }
    }
}
