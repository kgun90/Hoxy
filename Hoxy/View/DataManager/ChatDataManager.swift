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

protocol ChatRoomDataDelegate {
    func getChatContentData(_ chatData: [ChattingModel])
}

struct ChatDataManager {
    var listDelegate : ChatListDataDelegate?
    var contentDelegate : ChatRoomDataDelegate?
    func getChats() {
        if let uid = Auth.auth().currentUser?.uid {
            set.fs.collection(set.Table.chatting)
                .whereField("member", arrayContains: uid)
                .addSnapshotListener { (snapshot, error) in
                var listData: [ChatListModel] = []
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let documents = snapshot?.documents {
                        for doc in documents {
                            let data = doc.data()
                            let chatID = doc.documentID
                            let chatData = ChatListModel(
                                post: data["post"] as? DocumentReference,
                                member: (data["member"] as? [String])!,
                                nickname: data["nickname"] as! Dictionary<String, Any>,
                                chatID: chatID
                            )
                          
                            listData.append(chatData)
                        }
                        listDelegate?.getChatListData(listData)
                    }
                }
            }
        }
        
    }
    
    func getChattingData(_ chatID: String) {
        set.fs.collection(set.Table.chatting)
            .document(chatID)
            .collection("chat")
            .order(by: "date", descending: false)
            .addSnapshotListener { (snapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let documents = snapshot?.documents {
                        var chats: [ChattingModel] = []
                        for doc in documents {
                            let data = doc.data()
                            let time = data["date"] as! Timestamp
                            let chatting = ChattingModel(
                                content: data["content"] as! String,
                                sender: data["sender"] as! DocumentReference,
                                date: time.dateValue())
                            chats.append(chatting)
                        }
                        self.contentDelegate?.getChatContentData(chats)
                    }
                }
            }
    }
}
