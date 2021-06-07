//
//  TagDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/03.
//

import Foundation

protocol RequestTagProtocol {
    func getTagList(_ tagDataList: [TagModel])
}

struct TagDataManager {
    var delegate: RequestTagProtocol?
    
    func requestTagList() {   
        set.fs.collection(set.Table.tag).order(by: "count", descending: true)
            .addSnapshotListener { (querySanpshot, error ) in
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                if let snapshotocuments = querySanpshot?.documents {
                    var tagDataList = [TagModel]()
                   
                    for doc in snapshotocuments {
                        let data = doc.data()
                        let tagData = TagModel(name: data["name"] as? String, count: data["count"] as? Int)
                    
                        tagDataList.append(tagData)
                       
                    }
                    delegate?.getTagList(tagDataList)
                }
            }
    }
}
