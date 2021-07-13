//
//  WriteDataManager.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/25.
//

import Foundation
import Firebase

struct WriteDataManager {
    static func createPost(_ postModel: [String: Any], _ nickName: String) {
        guard let currentID = Auth.auth().currentUser?.uid else { return }
        guard let writer = postModel["writer"] as? DocumentReference else { return }
        guard let tags = postModel["tag"] as? [String] else { return }
        guard let communication = postModel["communication"] as? Int else { return }


        let post = Constants.POST_COLLECTION.addDocument(data: postModel)

       
        let chat = Constants.CHAT_COLLECTION.addDocument(data: [
            "date": Date(),
            "member": [currentID],
            "nickname": [currentID: nickName],
            "post" : post
        ])
        
        TagDataManager.addTagData(tags: postModel["tag"] as! [String])
        
        UserDataManager.getUserData(byReference: writer) { user in
            let participation = user.participation
            writer.updateData(["participation" : participation + 1])
        }
                
        var tag = tags
        tag.insert(Constants.communicationLevel[communication], at: 0)
        
        post.updateData([
            "tag": tag,
            "chat" : chat
        ])
        

    }
    
    static func updatePost(_ post: [String: Any], _ uid: String) {
        guard let tags = post["tag"] as? [String] else { return }
        guard let communication = post["communication"] as? Int else { return }
        
        Constants.POST_COLLECTION.document(uid).updateData(post)
        
        TagDataManager.addTagData(tags: tags)
        
        var tag = tags
        tag.insert(Constants.communicationLevel[communication], at: 0)
        
        Constants.POST_COLLECTION.document(uid).updateData([ "tag": tag ])
    }
}
