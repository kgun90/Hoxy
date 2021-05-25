//
//  HomeViewModel.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/24.
//

import Foundation
import CoreLocation

struct HomeViewModel: PostDataDelegate {
    let postData = Observable([PostDataModel()])
    var postDataManager = PostDataManager()
    
    mutating func requestData() {
        postDataManager.delegate = self
        postDataManager.requestPostData()
    }
    
    func getPostData(_ postData: [PostDataModel]) {
        self.postData.value = postData
    }
    
    func locationChangeAction(_ postData: [PostDataModel], _ index: Int) {
        if index == 0 {
            self.postData.value = postData.filter ({ (post: PostDataModel) -> Bool in
                let location = CLLocation(latitude: post.location!.latitude, longitude: post.location!.longitude)
                return location.distance(from: LocationService.currentLocation!) < 5000
            })
        } else {
            self.postData.value = postData.filter ({ (post: PostDataModel) -> Bool in
                let location = CLLocation(latitude: post.location!.latitude, longitude: post.location!.longitude)
                return location.distance(from: LocationService.userLocation!) < 5000
            })
        }
    }
    
    func addViewCount(_ id: String, _ currentViewCount: Int) {
        set.fs.collection(set.Table.post).document(id).updateData([
            "view": currentViewCount + 1
        ])
    }
}
