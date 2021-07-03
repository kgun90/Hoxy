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
    let title = Observable("")
    
    let post = Observable(PostDataModel(uid: "", dictionary: [:]))
    let relatedPost = Observable([PostDataModel]())

    func getPostData(postID: String) {
        PostDataManager.getPostData(byID: postID) { data in
            self.post.value = data
        }
    }
    
    func getRelatedPostData() {
        PostDataManager.getPostListData { posts in
            relatedPost.value = posts.filter({ data in
                self.post.value.id != data.id && self.post.value.communication == data.communication
            })
        }        
    }
    
    func applyButtonCheck(_ currentPost: PostDataModel?) {
        guard let currentPost = currentPost else { return }
        
        ChatDataManager.getChattingData(byReference: currentPost.chat) { data in
            counterLabel.value = " \(data.member.count)/\(currentPost.headcount)"
            
            if currentPost.writer == Auth.auth().currentUser {
                submitButtonCondition(.offWriter)
                return
            } else {
                if data.member.contains(Auth.auth().currentUser!.uid) {
                    self.submitButtonCondition(.offAlready)
                    return
                } else if data.member.count == currentPost.headcount {
                    self.submitButtonCondition(.offOver)
                    return
                }
            }
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

}
