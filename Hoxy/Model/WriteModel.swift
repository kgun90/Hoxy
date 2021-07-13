//
//  WriteModel.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/27.
//

import Foundation
import UIKit.UIColor
import Firebase

struct WriteButtonModel {
    var color: UIColor = #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1)
    var enable = false
    var title: String = ""
}

struct WriteContentsModel {
    var title = ""
    var content = ""    
    var town = ""
    var location: GeoPoint?
    var headCount = 0
    var communication = 0
    var emoji = ""
    var start: Date?
    var duration = 0
    var tag: [String] = []
    var view = 0
}

struct WriteMenuModel {
    var location = ""
    var headCount = ""
    var communicationLevel = ""
    var meetingTime = ""
    var meetingDuration = ""
}
