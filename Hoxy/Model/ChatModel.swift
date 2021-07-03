//
//  ChattingModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/17.
//

import Foundation
import Firebase

struct ChatModel {
    let content: String
    let date: Date
    let sender: DocumentReference
    
    init (dictionary: [String: Any]) {
        self.content = dictionary["content"] as? String ?? ""
        let time = dictionary["date"] as! Timestamp
        self.date = time.dateValue()
        self.sender = (dictionary["sender"] as? DocumentReference)! 
    }
}

struct ChattingModel {
    let date: Date
    let member: [String]
    let nickname: [String: Any]
    let post: DocumentReference
    
    init(dictionary: [String: Any]) {
        let time = dictionary["date"] as! Timestamp
        date = time.dateValue()
        member = dictionary["member"] as? [String] ?? []
        nickname =  dictionary["nickname"] as? [String: String] ?? ["":""]
        post = dictionary["post"] as! DocumentReference
    }
}

struct ChatListModel {
    let chat: ChattingModel
    let id: String
}

struct SenderInfoModel {
    let nickname: String
    let senderNickname: String
    let senderId: String
    
    init (id: String, dictionary: [String: Any]) {
        let data = dictionary["nickname"] as? [String: String] ?? ["":""]
        self.nickname = data[id] ?? ""
        self.senderNickname = data[id] ?? ""
        self.senderId = id
    }
}
