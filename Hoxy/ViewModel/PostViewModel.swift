//
//  PostViewModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/09.
//

import Foundation
import Firebase

struct PostViewModel {
    let applyButton = Observable(PostApplyButtonModel())
    let counterLabel = Observable("")
    
    func applyButtonCheck(_ currentPost: PostDataModel) {
        if currentPost.writer?.documentID == Auth.auth().currentUser?.uid {
            submitButtonCondition(.offWriter)
            return
        } else {
            currentPost.chat?.addSnapshotListener({ (snapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                    return
                } else {
                    if let data = snapshot?.data() {
                        let currentMember = data["member"] as! [String]
                        counterLabel.value = " \(currentMember.count)/\(currentPost.headcount)"
                        print(currentMember)
                        if currentMember.contains(Auth.auth().currentUser!.uid) {
                            self.submitButtonCondition(.offAlready)
                            return
                        } else if currentMember.count == currentPost.headcount {
                            self.submitButtonCondition(.offOver)
                            return
                        }
                    }
                }
            })
        }
        submitButtonCondition(.on)
    }
    
    func submitButtonCondition(_ state: buttonsStatus) {
        applyButton.value.color = state == .on ? .mainYellow : .mainBackground
        applyButton.value.enable = state == .on ? true : false

        switch state {
        case .on:
            applyButton.value.title = "신청하기"
        case .offOver:
            applyButton.value.title = "인원마감"
        case .offAlready:
            applyButton.value.title = "신청완료"
        case .offWriter:
            applyButton.value.title = "나의모임"
            
        }
    }
//    var
}
