//
//  TagModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/20.
//

import Foundation

struct TagModel{
    let name: String
    let count: Int
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.count = dictionary["count"] as? Int ?? 0
    }
}

struct TagAlertModel {
    var title: String?
    var message: String?
}
