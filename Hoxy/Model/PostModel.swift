//
//  PostModel.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/12.
//

import Foundation
import Firebase

public class PostModel {
    public let birth: Int
    public let city: String
    public let email: String
    public let emoji: String
    public let exp: Int
    public let location: GeoPoint
    public let participation: Int
    public let phone: String
    public let town: String
    public let uid: String
    
    public init(birth: Int, city: String, email: String, emoji: String, exp: Int, location: GeoPoint, participation: Int, phone: String, town: String, uid: String) {
        self.birth = birth
        self.city = city
        self.email = email
        self.emoji = emoji
        self.exp = exp
        self.location = location
        self.participation = participation
        self.phone = phone
        self.town = town
        self.uid = uid
    }
    
}
