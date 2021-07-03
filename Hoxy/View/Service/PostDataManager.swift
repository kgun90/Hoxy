//
//  PostDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import UIKit
import Firebase

//protocol SingleDataDelegate {
//    func getSingleData(_ postData: PostDataModel)
//}

struct PostDataManager {
    
//    MARK: - 작성된 글 목록을 불러옴 -> HomeVC
    static func getPostListData(completion: @escaping ([PostDataModel]) -> Void) {
        Constants.POST_COLLECTION.order(by: "date", descending: true)
            .addSnapshotListener { (snapshot, error ) in
                var postList: [PostDataModel] = []
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                guard let documents = snapshot?.documents else { return }
                
                documents.forEach { document in
                    let data = document.data()
                    postList.append(PostDataModel(uid: document.documentID, dictionary: data))
                    completion(postList)
                } 
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
        post.chat?.getDocument(completion: { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            var member = data["member"] as? [String] ?? []
            member.append(uid)
            post.chat?.updateData([
                "member": member,
                "nickname.\(uid)": nickname
            ])
            
        })
    }
    
//    MARK: - 모임글 삭제
    static func deletaAction(post: PostDataModel) {
        post.chat?.delete()
        Constants.POST_COLLECTION.document(post.id).delete()
    }
}
