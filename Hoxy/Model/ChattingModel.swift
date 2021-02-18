//
//  ChattingModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/17.
//

import Foundation
import Firebase

struct ChattingModel {
    var content: String = ""
    var sender: DocumentReference?
    var date: Date = Date()
}
