//
//  ChatDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/15.
//

import Foundation
import Firebase

protocol ChatListDataDelegate {
    func getChatListData(_ chatListData: [ChatListModel])
}

struct ChatDataManager {
    var listDelegate : ChatListDataDelegate?
    
    func getChats() {
        if let uid = Auth.auth().currentUser?.uid {
            set.fs.collection(set.Table.chatting).whereField("member.\(uid)", isNotEqualTo: "").addSnapshotListener { (snapshot, error) in
                var listData: [ChatListModel] = []
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let documents = snapshot?.documents {
                        for doc in documents {
                            let data = doc.data()
                            let chatData = ChatListModel(
                                post: data["post"] as? DocumentReference,
                                member: data["member"] as! Dictionary<String, Any>)
                          
                            listData.append(chatData)
                        }
                        listDelegate?.getChatListData(listData)
                    }
                }
            }
        }
        
    }
    
    func getMeetingTime(_ date: Date) -> String {
        
        return ""
    }
}
