//
//  MemberModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/04.
//

import Foundation
import Firebase

struct MemberModel {
    let birth: Int
    let city: String
    let email: String
    let emoji: String
    let exp: Int
    var location: GeoPoint?
    let participation: Int
    let phone: String
    let town: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.birth = dictionary["birth"] as? Int ?? 0
        self.city = dictionary["city"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.emoji = dictionary["emoji"] as? String ?? ""
        self.exp = dictionary["exp"] as? Int ?? 0
        self.location = dictionary["location"] as? GeoPoint 
        self.participation = dictionary["participation"] as? Int ?? 0
        self.phone = dictionary["phone"] as? String ?? ""
        self.town = dictionary["town"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

struct BanDataModel {
    let active: Bool
    let chatting: DocumentReference
    let date: Date
    let user: DocumentReference
    
    init(dictionary: [String: Any]) {
        active = dictionary["active"] as? Bool ?? false
        chatting = dictionary["chatting"] as! DocumentReference
        let time = dictionary["date"] as! Timestamp
        date = time.dateValue()
        user = dictionary["user"] as! DocumentReference
    }
}
