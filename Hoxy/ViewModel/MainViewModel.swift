//
//  MainViewModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/07/01.
//

import Foundation
import CoreLocation

struct MainViewModel {
    let manager = LocationManager()
    let location = Observable(CLLocation())
    
 
}
