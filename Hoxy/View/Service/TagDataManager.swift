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
    
    static func addTagData(tags: [String]) {
        Constants.TAG_COLLECTION.getDocuments { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            var tagList: [TagModel] = []
            var tagNameList: [String] = []
            documents.forEach { document in
                let tag = TagModel(dictionary: document.data())
                tagNameList.append(tag.name)
                tagList.append(tag)
            }
            
            tagList.filter { tags.contains($0.name) }.forEach { tag in
                Constants.TAG_COLLECTION.document(tag.name).updateData([
                    "name": tag.name,
                    "count": tag.count + 1
                ])
            }
            
            tags.filter { !tagNameList.contains($0) }.forEach { tag in
                Constants.TAG_COLLECTION.document(tag).setData([
                    "name": tag,
                    "count": 1
                ])
            }
        }
    }
}
