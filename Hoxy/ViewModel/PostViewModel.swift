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
            var dataList = [PostDataModel]()
            dataList = posts.filter{ data in
                data.id != self.post.value.id && data.communication == self.post.value.communication
            }
            relatedPost.value = dataList
        }        
    }
    
    func applyButtonCheck(_ currentPost: PostDataModel?) {
        guard let currentPost = currentPost else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        
        ChatDataManager.getChattingData(byReference: currentPost.chat) { data in
            counterLabel.value = " \(data.member.count)/\(currentPost.headcount)"
            
            if currentPost.writer?.documentID == currentUser.uid {
                submitButtonCondition(.offWriter)
                return
            } else {
                if currentPost.start < Date() {
                    self.submitButtonCondition(.offExpired)
                    return
                }
                 else if data.member.contains(currentUser.uid) {
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
            
        case .offExpired:
            applyButton.value.title = "신청기간종료"
        }
    }

}
