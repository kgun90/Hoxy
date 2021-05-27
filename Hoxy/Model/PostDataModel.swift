//
//  PostDataModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import Foundation
import Firebase
import UIKit.UIColor

struct PostDataModel{
    var id: String = ""
    var title: String = ""
    var content: String = ""
    var writer: DocumentReference?
    var headcount: Int = 0
    var tag: [String] = []
    var date: Date = Date()
    var emoji: String = ""
    var communication: Int = 0
    var start: Date = Date()
    var duration: Int = 0
    var town: String = ""
    var location: GeoPoint?
    var view: Int = 0
    var chat: DocumentReference?
}

struct PostApplyButtonModel {
    var title = ""
    var color: UIColor = .mainBackground
    var enable = false
}
