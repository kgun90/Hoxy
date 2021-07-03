//
//  WriteDataManager.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/25.
//

import Foundation
import Firebase

struct WriteDataManager {
    static func createPost(_ postModel: PostDataModel, _ nickName: String) {
        guard let currentID = Auth.auth().currentUser?.uid else { return }
        guard let writer = postModel.writer else { return }
        guard let location = postModel.location else { return }
        
        let post = Constants.POST_COLLECTION.addDocument(data: [
            "title": postModel.title,
            "content": postModel.content,
            "writer": writer,
            "headcount": postModel.headcount,
            "location": location,
            "tag": postModel.tag,
            "date": postModel.date,
            "emoji":  postModel.emoji,
            "communication":  postModel.communication,
            "start": postModel.start,
            "duration":  postModel.duration,
            "town":  postModel.town,
            "view": postModel.view
        ])
       
        let chat = Constants.CHAT_COLLECTION.addDocument(data: [
            "date": Date(),
            "member": [currentID],
            "nickname": [currentID: nickName],
            "post" : post
        ])
                
        post.updateData([
            "chat" : chat
        ])
    }
    
    static func updatePost(_ postModel: PostDataModel, _ uid: String) {
        guard let location = postModel.location else { return }
        
        Constants.POST_COLLECTION.document(uid).updateData([
            "title": postModel.title,
            "content": postModel.content,
            "headcount": postModel.headcount,
            "location": location,
            "tag": postModel.tag,
            "date": postModel.date,
            "emoji":  postModel.emoji,
            "communication":  postModel.communication,
            "start": postModel.start,
            "duration":  postModel.duration,
            "town":  postModel.town
        ])
    }
}
