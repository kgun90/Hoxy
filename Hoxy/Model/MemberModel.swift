//
//  MemberModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/04.
//

import Foundation
import Firebase

struct MemberModel {
    var birth: Int = 0
    var city: String = ""
    var email: String = ""
    var emoji: String = ""
    var exp: Int = 0
    var location: GeoPoint?
    var participation: Int = 0
    var phone: String = ""
    var town: String = ""
    var uid: String = ""
}
