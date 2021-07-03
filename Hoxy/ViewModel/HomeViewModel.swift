//
//  HomeViewModel.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/24.
//

import Foundation
import CoreLocation
import Firebase

struct HomeViewModel {
    let postData = Observable([PostDataModel]())
    let menuItem = Observable([""])
    
    let manager = LocationManager()
    func fetchPostsData() {
        PostDataManager.getPostListData { data in
            self.postData.value = data
        }
    }

    
    func locationChangeAction(_ postData: [PostDataModel], _ index: Int) {
        if index == 0 {
            self.postData.value = postData.filter ({ (post: PostDataModel) -> Bool in
                let location = CLLocation(latitude: post.location!.latitude, longitude: post.location!.longitude)
                return location.distance(from: LocationService.currentLocation()!) < 5000
            })
        } else {
            self.postData.value = postData.filter ({ (post: PostDataModel) -> Bool in
                let location = CLLocation(latitude: post.location!.latitude, longitude: post.location!.longitude)
                return location.distance(from: LocationService.userLocation()!) < 5000
            })
        }
    }
    
    func addViewCount(_ id: String, _ currentViewCount: Int) {
        Constants.POST_COLLECTION.document(id).updateData([
            "view": currentViewCount + 1
        ])
    }
   
    
    func currentLocation() {
        manager.startUpdatingLocation()
        guard let location = manager.latestLocation else { return }
        
        let geocode = CLGeocoder()
        geocode.reverseGeocodeLocation(location) { (placemark, error) in
            guard
                let mark = placemark,
                let town = mark.first?.subLocality
            else {
                return
            }
            LocationService.saveCurrentLocation(town: town, location: location)
            Log.any(town)
        }
        
        manager.stopUpdatingLocation()
    }
    
    func getMenuItem() {
        menuItem.value = LocationService.getTownData()
    }
}
