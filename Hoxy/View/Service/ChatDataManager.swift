//
//  ChatDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/15.
//

import Foundation
import Firebase
protocol ChatListDelegate {
    func getChatList(listData: [ChatListModel])
}

struct ChatDataManager {
    var delegate: ChatListDelegate?
    
//  MARK: - Chat List
    static func getChatListData(completion: @escaping ([ChatListModel]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        var chats: [ChatListModel] = []
        
        Constants.CHAT_COLLECTION.whereField("member", arrayContains: userID).order(by: "date", descending: false).addSnapshotListener { snapshot, error in
           
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            
            documents.forEach { document in
                let chatting = ChattingModel(dictionary: document.data())
                Log.any(chatting)
               
                PostDataManager.getPostData(byReference: chatting.post) { model in
                  
                    if !model.start.getEndtime(start: model.start, duration: model.duration).isExpired {
                        let chatModel = ChatListModel(chat: chatting, id: document.documentID)
                        Log.any(chatModel)
                        chats.append(chatModel)
                        completion(chats)
                    }
                }
            }
        }
    }
    
    static func getChats(completion: @escaping ([ChatListModel]) -> Void) {
        guard let current = Auth.auth().currentUser else { return }
        var chatList: [ChatListModel] = []
        
        Constants.CHAT_COLLECTION.order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
           
            let chats = documents.filter {
                let data = $0.data()
                let member = data["member"] as? [String] ?? []
                return member.contains(current.uid)
            }
            
            chats.forEach { document in
                let chatData = ChattingModel(dictionary: document.data())
                let chatId = document.documentID
                
                let chat = ChatListModel(chat: chatData, id: chatId)

                chatList.append(chat)

            }
            completion(chatList)
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
    
    static func unblockUser(byID: String) {
        guard let currentID = Auth.auth().currentUser?.uid else { return }
        Constants.MEMBER_COLLECTION.document(currentID).collection("ban").document(byID).addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else { return }
            let pair = data["pair"] as? DocumentReference
            pair?.delete()
        }
        
        Constants.MEMBER_COLLECTION.document(currentID).collection("ban").document(byID).delete()
    }
    
//    MARK: - 방 나가기
    static func leaveRoom(chatData chat: DocumentReference, userID id: String) {
        var member: [String] = []
        chat.getDocument { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else { return }
    
            member = data["member"] as? [String] ?? []
            member.remove(at: member.firstIndex(of: id)!)
            
            chat.updateData(["member": member])
            
            guard let post = data["post"] as? DocumentReference else { return }
            guard let current = Auth.auth().currentUser else { return }
            
            PostDataManager.getPostData(byReference: post) { data in
                if data.start > Date() {
                    UserDataManager.getUserData(byID: current.uid) { data in
                        let participation = data.participation
                        if participation > 0 {
                            Constants.MEMBER_COLLECTION.document(current.uid).updateData([
                                "participation": participation - 1
                            ])
                        }
                    }
                }
            }
        }
    }
//    방 삭제하기
    static func removeMeeting(chatData: DocumentReference) {
        guard let current = Auth.auth().currentUser else { return }
        
        self.getChattingData(byReference: chatData) { chat in
            PostDataManager.getPostData(byReference: chat.post) { post in
                
//                Constants.ALERT_COLLECTION.addDocument(data:[
//                    "title": "\(post.title)모임 삭제 알림",
//                    "content": "참여 신청했던 \(post.title) 모임이 삭제 되었습니다.",
//                    "date": Date(),
//                    "emoji": post.emoji,
//                    "type": "delete",
//                    "target": post.chat?.documentID,
//                    "uid": post.writer?.documentID
//                ])
                
                if post.start > Date() {
                    UserDataManager.getUserData(byID: current.uid) { data in
                        let participation = data.participation
                        if participation > 0 {
                            Constants.MEMBER_COLLECTION.document(current.uid).updateData([
                                "participation": participation - 1
                            ])
                        }
                    }
                }
            }
            Constants.POST_COLLECTION.document(chat.post.documentID).delete()
        }
        chatData.delete()
    }
}
