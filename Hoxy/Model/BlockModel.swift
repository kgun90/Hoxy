//
//  BlackModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/28.
//

import Foundation
import Firebase

struct BlockModel {
    var user: DocumentReference?
    var date: Date = Date()
    var chatting: DocumentReference?
    var pair: DocumentReference?
    var active: Bool?
    
    func toDic() -> Dictionary<String, Any?> {
        return [
            "user": user,
            "date": date,
            "chatting": chatting,
            "pair": pair,
            "active": active
    ]
    }
}
