//
//  Contants.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/25.
//

import UIKit
import Firebase

struct set {
    static let fs = Firestore.firestore()

    struct Table {
        static let member = "member"
        static let chatting = "chatting"
        static let post = "post"
    }
}
