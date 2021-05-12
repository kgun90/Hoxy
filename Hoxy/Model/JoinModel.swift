//
//  JoinModel.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/12.
//

import Foundation

public class JoinModel {
    public var email: String
    public var pass: String
    public var phone: String
    public var city: String
    public var town: String
    public var uid: String
    public var age: Int
    
    public init(email: String = "", pass: String = "", phone: String = "", city: String = "", town: String = "", uid: String = "", age: Int = 0) {
        self.email = email
        self.pass = pass
        self.phone = phone
        self.city = city
        self.town = town
        self.uid = uid
        self.age = age
    }
}
