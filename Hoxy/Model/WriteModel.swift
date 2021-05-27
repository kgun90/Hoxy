//
//  WriteModel.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/27.
//

import Foundation
import UIKit.UIColor

struct WriteButtonModel {
    var color: UIColor = #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1)
    var enable = false
}

struct WriteContentsModel {
    var title = ""
    var location = ""
    var count = ""
    var communicationLevel = ""
    var duration = ""
    var content = ""
}
