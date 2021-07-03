//
//  PostDataModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import Foundation
import Firebase
import UIKit.UIColor

struct PostDataModel {
    let id: String
    let title: String
    let content: String
    var writer: DocumentReference?
    let headcount: Int
    let tag: [String]
    let date: Date
    let emoji: String
    let communication: Int
    let start: Date
    let duration: Int
    let town: String
    var location: GeoPoint?
    let view: Int
    var chat: DocumentReference?
    
    init (uid: String, dictionary: [String: Any]) {
        id = uid
        title = dictionary["title"] as? String ?? ""
        content = dictionary["content"] as? String ?? ""
        writer = dictionary["writer"] as? DocumentReference
        headcount = dictionary["headcount"] as? Int ?? 0
        tag = dictionary["tag"] as? [String] ?? []
        date = (dictionary["date"] as? Timestamp ?? Timestamp()).dateValue()
        emoji = dictionary["emoji"] as? String ?? ""
        communication = dictionary["communication"] as? Int ?? 0
        start = (dictionary["start"] as? Timestamp ?? Timestamp()).dateValue()
        duration = dictionary["duration"] as? Int ?? 0
        town = dictionary["town"] as? String ?? ""
        location = dictionary["location"] as? GeoPoint
        view = dictionary["view"] as? Int ?? 0
        chat = dictionary["chat"] as? DocumentReference
    }
}

struct PostApplyButtonModel {
    var title = ""
    var color: UIColor = .mainBackground
    var enable = false
}

