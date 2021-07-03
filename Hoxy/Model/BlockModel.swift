//
//  BlackModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/28.
//

import Foundation
import Firebase

struct BlockModel {
    let user: DocumentReference?
    let date: Date
    let chatting: DocumentReference?
    let pair: DocumentReference?
    let active: Bool?

    func toDic() -> Dictionary<String, Any?> {
        return [
            "user": user,
            "date": date,
            "chatting": chatting,
            "pair": pair,
            "active": active
        ]
    }
    
    init(dictionary: [String: Any?]) {
        user = dictionary["user"] as? DocumentReference
        date = (dictionary["date"] as? Timestamp ?? Timestamp()).dateValue()
        chatting = dictionary["chatting"] as? DocumentReference
        pair = dictionary["pair"] as? DocumentReference 
        active = dictionary["active"] as? Bool ?? false
    }
   
}
