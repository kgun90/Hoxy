//
//  ReportModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/26.
//

import Foundation
import Firebase

struct ReportModel {
    var content: String = ""
    var date: Date = Date()
    var post: DocumentReference?
    var writer: DocumentReference?
}
