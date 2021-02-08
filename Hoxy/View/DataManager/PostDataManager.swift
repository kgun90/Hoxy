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

protocol SingleDataDelegate {
    func getSingleData(_ postData: PostDataModel)
}

protocol CommLevelDelegate {
    func getFilteredData(_ postData: [PostDataModel])
}

struct PostDataManager {
    var delegate: PostDataDelegate?
    var singleDelegate: SingleDataDelegate?
    var commLevelDelegate: CommLevelDelegate?
    
    func requestPostData() {
        set.fs.collection(set.Table.post).order(by: "date", descending: true)
            .addSnapshotListener { (querySanpshot, error ) in
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
                                id: doc.documentID,
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
                                location: data["location"] as? GeoPoint,
                                view: data["view"] as! Int,
                                chat: data["chat"] as? DocumentReference
                            )
                            postList.append(postData)
                           
                        }
                        self.delegate?.getPostData(postList)
                    }
                }
            }
        
    }
    
    func requestSingleData(_ id: String) {
        set.fs.collection(set.Table.post).document(id)
//            .getDocument { (snapshot, error ) in
            .addSnapshotListener { (snapshot, error ) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    let writeTime = data["date"] as! Timestamp
                    let startTime = data["start"] as! Timestamp
                    let postData = PostDataModel(
                        id: snapshot?.documentID ?? "",
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
                    singleDelegate?.getSingleData(postData)
                }
               
            }
        }
    }
    
//    func requestFilteredData(_ communicationLevel: Int, )
}
