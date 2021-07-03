//
//  WriteViewModel.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/25.
//

import Foundation
import UIKit.UIColor
import Firebase

struct WriteViewModel{
    let navTitle = Observable("")
    let buttonTitle = Observable("")
    let writer = Observable("")
    let nickname = Observable("")
    
    let writeMenu = Observable(WriteMenuModel())
    let submitButton = Observable(WriteButtonModel())
    let postData = Observable(PostDataModel(uid: "", dictionary: [:]))
    
    var writeContents = WriteContentsModel()
    
    var postID: String?
    
    var validContents: Bool {
        return writeContents.title.count > 5
            && writeContents.content.count >= 10
            && writeContents.communication != 0
            && writeContents.town != ""
            && writeContents.headCount != 0
            && writeContents.duration != 0
    }
    
    var writeMode: writeMode {
        return postID == nil ? .write : .update
    }
    
    func titleSet() {
        navTitle.value = writeMode == .write ? "모임글 작성" : "작성글 수정"
        buttonTitle.value = writeMode == .write ? "작성하기" : "수정하기"
    }
    
    func getPostData(_ postID: String) {
        PostDataManager.getPostData(byID: postID) { data in
            postData.value = data
        }
    }
    
    func requestUserData() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        
        UserDataManager.getUserData(byID: id) {  data in
            self.writer.value = data.email
            
            if writeMode == .write {
                let name:String = "".nicknameGenerate()
                self.nickname.value = name
            } else {
                guard let chat = postData.value.chat else { return }
                ChatDataManager.getSenderInfoData(chatID: chat.documentID, senderID: id) { sender in
                    self.nickname.value = sender.nickname
                }
            }
        }
    }
    
    func submitButtonValidation() {
        submitButton.value.color = validContents ? .mainYellow : .disabledGray
        submitButton.value.enable = validContents ? true : false
    }
    

    
    mutating func pickerViewAction(mode: writeMenu, row: Int) {
        switch mode {
        case .location:
            writeMenu.value.location = LocationService.getTownData()[row]
            
            guard let coordinate = LocationService.getLocationData()[row]?.coordinate else { return }
            writeContents.town = LocationService.getTownData()[row]
            writeContents.location = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
        case .headCount:
            writeMenu.value.headCount = String(Constants.headCount[row])
            writeContents.headCount = Constants.headCount[row]
            
        case .communicationLevel:
            writeMenu.value.communicationLevel = Constants.communicationLevel[row]
            
            let rand = Int.random(in: 0 ... 2)
            writeContents.emoji = Constants.communicationEmoji[row][rand]
            writeContents.communication = row + 1
            
        case .meetingDuration:
            writeMenu.value.meetingDuration = Constants.meetingDuration[row]
            writeContents.duration = (row + 1) * 30
            
        default:
            return
        }
    }
    
    
    func submitAction() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let location = writeContents.location else { return }
        let postData = [
            "title": writeContents.title,
            "content": writeContents.content,
            "writer": Constants.MEMBER_COLLECTION.document(uid),
            "headcount": writeContents.headCount,
            "tag": writeContents.tag,
            "date": Date(),
            "emoji": writeContents.emoji,
            "communication":  writeContents.communication,
            "start": writeContents.start,
            "duration":  writeContents.duration,
            "town":  writeContents.town,
            "location": location
        ] as [String : Any]
        let post = PostDataModel(uid: uid, dictionary: postData)
        
        if writeMode == .write {
            WriteDataManager.createPost(post, nickname.value)
        } else {
            WriteDataManager.updatePost(post, nickname.value)
        }
      
    }
}

