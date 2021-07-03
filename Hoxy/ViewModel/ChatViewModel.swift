//
//  ChatViewModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/23.
//

import Foundation
import Firebase

struct ChatViewModel {
    let roomTitle = Observable("")
    let chatListData = Observable([ChatListModel]())
    
    func getChatListData() {
        chatListData.value.removeAll()
        ChatDataManager.getChatListData { data in
            self.chatListData.value = data
        }
    }
    
    func getRoomTitle(_ postID: String) {
        PostDataManager.getPostData(byID: postID) { data in
            roomTitle.value = data.title
        }
    }
}
