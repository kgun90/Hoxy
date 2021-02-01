//
//  PostDataModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import Foundation
import Firebase

struct PostDataModel{
    var title: String = ""
    var content: String = ""
    var writer: DocumentReference
    var headcount: Int = 0
    var tag: [String] = []
    var date: Date
    var emoji: String = ""
    var communication: Int = 0
    var start: Date
    var duration: Int = 0
    var city: String = ""
    var town: String = ""
    var location: GeoPoint
    var view: Int = 0
    var chat: DocumentReference
}
