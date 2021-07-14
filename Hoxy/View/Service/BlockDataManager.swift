//
//  BlockDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/07/14.
//

import Foundation
import Firebase

struct BlockDataManager {
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
