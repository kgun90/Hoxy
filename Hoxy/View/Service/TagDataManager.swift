//
//  TagDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/03.
//

import Foundation

struct TagDataManager {
    static func getTagData(completion: @escaping ([TagModel]) -> Void) {
        Constants.TAG_COLLECTION.order(by: "count", descending: true).addSnapshotListener { snapshot, error in
            var tagDataList = [TagModel]()
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                tagDataList.append(TagModel(dictionary: document.data()))
                completion(tagDataList)
            }
        }
    }
}
