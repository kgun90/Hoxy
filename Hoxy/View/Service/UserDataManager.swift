//
//  UserDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/04.
//

import UIKit
import Firebase


struct UserDataManager {
    static func getUserData(byID id: String, completion: @escaping (MemberModel) -> Void) {
        Constants.MEMBER_COLLECTION.document(id).getDocument { document, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = document?.data() else { return }
            completion(MemberModel(dictionary: data))
        }
    }
    
    static func getUserData(byReference reference: DocumentReference?, completion: @escaping (MemberModel) -> Void) {
        guard let reference = reference else { return }
        reference.getDocument { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = snapshot?.data() else { return }
            completion(MemberModel(dictionary: data))
        }
    }
    
    static func getBanListData(completion: @escaping ([BlockModel]) -> Void) {
        guard let id = Auth.auth().currentUser?.uid else { return }
        Constants.MEMBER_COLLECTION.document(id).collection("ban").addSnapshotListener { snapshot, error in
            var blockList = [BlockModel]()
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
          
            if documents.isEmpty {
                blockList = []
            } else {
                documents.forEach {
                    let data = BlockModel(id: $0.documentID, dictionary: $0.data())
                    blockList.append(data)
                }
            }

            completion(blockList)
        }
    }
}
