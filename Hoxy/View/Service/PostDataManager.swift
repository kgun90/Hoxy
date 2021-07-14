//
//  PostDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import UIKit
import Firebase

struct PostDataManager {
    
//    MARK: - 작성된 글 목록을 불러옴 -> HomeVC
    static func getPostListData(completion: @escaping ([PostDataModel]) -> Void) {
        Constants.POST_COLLECTION.order(by: "start", descending: true).addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            var postList: [PostDataModel] = []
            documents.forEach { document in
                let data = document.data()
                let post = PostDataModel(uid: document.documentID, dictionary: data)
    
                postList.append(post)
            }
            completion(postList)
        }
    }
    //    MARK: - Reference 로 글정보 받음
    static func getPostData(byReference reference: DocumentReference, completion: @escaping (PostDataModel) -> Void) {
        reference.addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else { return }
            guard let id = snapshot?.documentID else { return }
            
            completion(PostDataModel(uid: id, dictionary: data))
        }
    }
    
    //    MARK: - Reference 로 글정보 받음
    static func getPostDataDocument(byReference reference: DocumentReference, completion: @escaping (PostDataModel) -> Void) {
        reference.getDocument { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else { return }
            guard let id = snapshot?.documentID else { return }
            
            completion(PostDataModel(uid: id, dictionary: data))
        }
    }
    
    //    MARK: - Document ID 로 글정보 받음
    static func getPostData(byID id: String, completion: @escaping (PostDataModel) -> Void) {
        Constants.POST_COLLECTION.document(id).addSnapshotListener { snapshot, error in
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                guard let data = snapshot?.data() else { return }
                guard let id = snapshot?.documentID else { return }
                
                completion(PostDataModel(uid: id, dictionary: data))
            }
    }
        
//    MARK: - 모임 신고
    func reportPost(_ reportData: ReportModel) {
        Constants.REPORT_COLLECTION.addDocument(data: [
            "content": reportData.content,
            "date": reportData.date,
            "post": reportData.post! as DocumentReference,
            "writer": reportData.writer! as DocumentReference
        ])
    }
    
//    MARK: - 모임 신청
    static func joinAction(post: PostDataModel, nickname: String) {
        guard let current = Auth.auth().currentUser else { return }
        post.chat?.getDocument(completion: { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else { return }
           
            
            var member = data["member"] as? [String] ?? []
            member.append(current.uid)
            post.chat?.updateData([
                "member": member,
                "nickname.\(current.uid)": nickname
            ])
        })
        
        UserDataManager.getUserData(byID: current.uid) { data in
            let participation = data.participation
            Constants.MEMBER_COLLECTION.document(current.uid).updateData([
                "participation": participation + 1
            ])
        }
      
        UserDataManager.getUserData(byID: current.uid) { data in
            Constants.ALERT_COLLECTION.addDocument(data:[
                "title": "\(nickname)님이 모임에 참가했습니다",
                "content": "'\(post.title)' 모임에 새로운 참가 신청이 왔어요 \n환영 인사를 해주세요~",
                "date": Date(),
                "emoji": data.emoji,
                "type": "apply",
                "target": post.chat?.documentID,
                "uid": post.writer?.documentID
            ])
        }
        
    }
    
//    MARK: - 모임글 삭제
    static func deletaAction(post: PostDataModel) {
        guard let writer = post.writer else { return }
        
        UserDataManager.getUserData(byReference: writer) { user in
            let participation = user.participation
            if participation > 0
                && post.start.getEndtime(start: post.start, duration: post.duration) < Date()  {
                writer.updateData(["participation" : participation - 1])
            }
        }
        
        post.chat?.delete()
        
        Constants.POST_COLLECTION.document(post.id).delete()
    }
}
