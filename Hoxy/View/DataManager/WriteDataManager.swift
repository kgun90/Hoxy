//
//  WriteDataManager.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/25.
//

import Foundation
import Firebase
protocol WriteDataDelegate {
//    func 
}

struct WriteDataManager {
    func createPost(_ postModel: PostDataModel, _ nickName: String) {
        let post = set.fs.collection(set.Table.post).addDocument(data: [
            "title": postModel.title,
            "content": postModel.content,
            "writer": postModel.writer! as DocumentReference,
            "headcount": postModel.headcount,
            "location": postModel.location! as GeoPoint,
            "tag": postModel.tag,
            "date": postModel.date,
            "emoji":  postModel.emoji,
            "communication":  postModel.communication,
            "start": postModel.start,
            "duration":  postModel.duration,
            "town":  postModel.town,
            "view": postModel.view
        ])
        
        let chat = set.fs.collection(set.Table.chatting).addDocument(data: [
            "member": [Auth.auth().currentUser?.uid],
            "nickname": [ Auth.auth().currentUser?.uid : nickName],
            "post" : post
        ])
        
        post.updateData([
            "chat" : chat
        ])
    }
    
    func updatePost(_ postModel: PostDataModel, _ uid: String) {
        set.fs.collection(set.Table.post).document(uid).updateData([
            "title": postModel.title,
            "content": postModel.content,
            "headcount": postModel.headcount,
            "location": postModel.location! as GeoPoint,
//            "tag": postModel.tag,
            "date": postModel.date,
            "emoji":  postModel.emoji,
            "communication":  postModel.communication,
            "start": postModel.start,
            "duration":  postModel.duration,
            "town":  postModel.town
        ])
    }
}
