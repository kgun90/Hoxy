//
//  PostDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import UIKit
import Firebase

protocol PostDataDelegate {
    func getPostData(_ postData: [PostDataModel])
}

struct PostDataManager {
    var delegate: PostDataDelegate?
   
    func requestPostData() {
        set.fs.collection(set.Table.post)
            .getDocuments { (querySanpshot, error) in
                var postList: [PostDataModel] = []
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshotocuments = querySanpshot?.documents {
                        for doc in snapshotocuments {
                            let data = doc.data()
                            let writeTime = data["date"] as! Timestamp
                            let startTime = data["start"] as! Timestamp
                            let postData = PostDataModel(
                                title: data["title"] as! String,
                                content: data["content"] as! String,
                                writer: data["writer"] as! DocumentReference,
                                headcount: data["headcount"] as! Int,
                                tag: data["tag"] as! [String],
                                date: writeTime.dateValue(),
                                emoji: data["emoji"] as! String,
                                communication: data["communication"] as! Int,
                                start: startTime.dateValue(),
                                duration: data["duration"] as! Int,
                                town: data["town"] as! String,
                                location: data["location"] as! GeoPoint,
                                view: data["view"] as! Int,
                                chat: data["chat"] as! DocumentReference
                            )
                            postList.append(postData)
                           
                        }
                        self.delegate?.getPostData(postList)
                    }
                }
            }
    }
}
