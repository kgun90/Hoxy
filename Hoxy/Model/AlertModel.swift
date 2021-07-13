//
//  AlertModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/07/05.
//

import Foundation
import Firebase

struct AlertModel {
    let content: String
    let date: Date
    let emoji: String   // apply: 입장한 유저 이모지, time: 해당 모임 이모지
    let target: String  // 이동 대상 PostID or ChatID
    let title: String
    let type: String    // apply: 모임 신청 알림, time: 모임 시간 알림
    let uid: String     // member uid
    
    init(dictionary: [String: Any]) {
        content = dictionary["content"] as? String ?? ""
        date = (dictionary["date"] as? Timestamp ?? Timestamp()).dateValue()
        emoji = dictionary["emoji"] as? String ?? ""
        target = dictionary["target"] as? String ?? ""
        title = dictionary["title"] as? String ?? ""
        type = dictionary["type"] as? String ?? ""
        uid = dictionary["uid"] as? String ?? ""
    }
    
}
