//
//  ChatDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/15.
//

import Foundation
import Firebase


struct ChatDataManager {
    
//  MARK: - Chat List
    static func getChatListData(completion: @escaping ([ChatListModel]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
       
        Constants.CHAT_COLLECTION.whereField("member", arrayContains: userID).order(by: "date", descending: false).addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            var chats = [ChatListModel]()
            documents.forEach { document in
                chats.append(ChatListModel(chat: ChattingModel(dictionary: document.data()), id: document.documentID))
                completion(chats)
            }
        }
    }
    
    // MARK: - Chatting Document 정보 얻어오기
    static func getChattingData(byReference reference: DocumentReference?, completion: @escaping (ChattingModel) -> Void) {
        guard let reference = reference else { return }
        reference.addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else { return }
            completion(ChattingModel(dictionary: data))
        }
    }
    
    // MARK: - Chatting Document 정보 얻어오기
    static func getChattingData(byID id: String, completion: @escaping (ChattingModel) -> Void) {
        Constants.CHAT_COLLECTION.document(id).addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else { return }
            completion(ChattingModel(dictionary: data))
        }
    }
    
    //   MARK: - 채팅 내용 받아오기
    static func getChatData(byId chatID: String, completion: @escaping ([ChatModel]) -> Void) {
        var chats = [ChatModel]()
        Constants.CHAT_COLLECTION.document(chatID).collection("chat").order(by: "date", descending: false).addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    chats.append(ChatModel(dictionary: data))
                    completion(chats)
                }
            })
        }
    }

//    MARK: Sender Info 받아오기
    static func getSenderInfoData(chatID: String, senderID: String, completion: @escaping (SenderInfoModel) -> Void) {
        Constants.CHAT_COLLECTION.document(chatID).addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else { return }
            completion(SenderInfoModel(id: senderID, dictionary: data))
        }
    }
    
//    MARK: - 채팅 작성하기
    static func sendChat(content: String, chatID: String) {
        if let uid = Auth.auth().currentUser?.uid {
            let sender = Constants.MEMBER_COLLECTION.document(uid)
            Constants.CHAT_COLLECTION.document(chatID).collection("chat")
                .addDocument(data: [
                    "content" :  content,
                    "sender" : sender,
                    "date" : Date()
                ])
        }
    }

//    MARK: - 이 사용자와 만나지 않기
    static func bloackUser(fromID: String, toID: String, chatID: String) {
        let me = Constants.MEMBER_COLLECTION.document(fromID)
        let user = Constants.MEMBER_COLLECTION.document(toID)
        let chatting = Constants.CHAT_COLLECTION.document(chatID)
        
    
        let ban = Constants.MEMBER_COLLECTION.document(user.documentID).collection("ban").addDocument(data:  [
            "user": me,
            "date": Date(),
            "chatting": chatting,
            "active": false
        ])
        
        let otherBan = Constants.MEMBER_COLLECTION.document(me.documentID).collection("ban").addDocument(data: [
            "user": user,
            "date": Date(),
            "chatting": chatting,
            "pair": ban,
            "active": true
        ])
        
        ban.updateData([ "pair": otherBan])
    }
    
//    MARK: - 방 나가기
    static func leaveRoom(chatData chat: DocumentReference, userID id: String) {
        var member: [String] = []
        chat.getDocument { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            if let data = snapshot?.data() {
                member = data["member"] as? [String] ?? []
            }
            member.remove(at: member.firstIndex(of: id)!)
            chat.updateData(["member": member])
        }
    }
}
