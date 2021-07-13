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
    let id: String

    func toDic() -> Dictionary<String, Any?> {
        return [
            "user": user,
            "date": date,
            "chatting": chatting,
            "pair": pair,
            "active": active
        ]
    }
    
    init(id: String, dictionary: [String: Any?]) {
       self.id = id
        user = dictionary["user"] as? DocumentReference
        date = (dictionary["date"] as? Timestamp ?? Timestamp()).dateValue()
        chatting = dictionary["chatting"] as? DocumentReference
        pair = dictionary["pair"] as? DocumentReference 
        active = dictionary["active"] as? Bool ?? false
    }
   
}
