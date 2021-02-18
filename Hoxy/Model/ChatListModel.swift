//
//  ChatListModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/15.
//

import Foundation
import Firebase

struct ChatListModel {
    var post: DocumentReference?
    var member: [String] = []
    var nickname: Dictionary<String, Any> = [:]
    var chatID: String = ""
}
