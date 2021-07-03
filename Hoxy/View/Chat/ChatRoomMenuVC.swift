//
//  ChatRoomMenuVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/22.
//

import UIKit
import Firebase

protocol ChatRoomMenuDelegate {
    func dismiss()
}

class ChatRoomMenuVC: UIViewController {
    var delegate: ChatRoomMenuDelegate?
    // MARK: - Properties
    lazy var topView = UIView().then {
        $0.backgroundColor = .white
        
        $0.addSubview(emojiLabel)
        $0.addSubview(titleLabel)
        $0.addSubview(meetingTimeLabel)
        $0.addSubview(gradeBugtton)
        
        emojiLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(23))
            $0.width.equalTo(Device.widthScale(43))
            $0.height.equalTo(Device.heightScale(43))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(28))
            $0.leading.equalToSuperview().offset(Device.widthScale(77))
        }
        meetingTimeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Device.heightScale(2))
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        gradeBugtton.snp.makeConstraints {
            $0.top.equalTo(meetingTimeLabel.snp.top)
            $0.leading.equalTo(meetingTimeLabel.snp.trailing).offset(Device.widthScale(3))
            $0.width.equalTo(Device.widthScale(28))
            $0.height.equalTo(Device.heightScale(14))
        }
        
    }
    
    lazy var emojiLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 40)
        $0.text = "🥳"
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 18)
        $0.textColor = .black
        $0.text = "test Title"
    }
    
    lazy var meetingTimeLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 11)
        $0.textColor = .meetingTimeOrange
        $0.text = "Test meeting time"
    }
    
    lazy var memberHeaderView = UIView().then {
        $0.backgroundColor = .white
        $0.addSubview(memberHeaderTitle)
        $0.addSubview(memberHeaderCount)
        
        memberHeaderTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(21))
        }
        
        memberHeaderCount.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(memberHeaderTitle.snp.trailing).offset(Device.widthScale(3))
        }
    }
    
    lazy var memberHeaderTitle = UILabel().then {
        $0.font = .BasicFont(.regular, size: 18)
        $0.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        $0.text = "참여 멤버"
    }
    
    lazy var memberHeaderCount = UILabel().then {
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .meetingTimeOrange
    }
    
    lazy var memberListStackView = UIStackView().then {
        $0.alignment = .fill
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 0
    }
    
    lazy var menuItemStackView = UIStackView().then {
        $0.alignment = .fill
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 0
    }
    
    let gradeBugtton = GradeButton(mode: .tableCell)
    var memberItem: [ChatMemberView] = []
    
    var postID = ""
    var chatID = ""
    var postDataManager = PostDataManager()
    var memberData: [String] = []
    var postData: PostDataModel?
    
  
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView.addBorder(toSide: .bottom, color: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1), borderWidth: 1)
        menuItemStackView.addBorder(toSide: .top, color: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1), borderWidth: 1)
        menuItemStackView.subviews.forEach {
            $0.addBorder(toSide: .bottom, color: #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1), borderWidth: 1)
        }
    }
    
    // MARK: - Selectors
    @objc func moveToPost() {
        let vc = PostVC()
        vc.postID = postID
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func leaveRoomAction() {
        let ok = UIAlertAction(title: "나가기", style: .default) { (action) in
            
            guard let currentUser = Auth.auth().currentUser?.uid else {return}
            ChatDataManager.leaveRoom(chatData: (self.postData?.chat)!, userID: currentUser)
            
            self.dismiss(animated: true) {
                self.delegate?.dismiss()
            }
        }
        presentAlert(title: "모임 떠나기", message: "채팅방을 나가시면 모임을 떠나게 됩니다. 계속 하시겠습니까?", isCancelActionIncluded: true, with: ok)
    }
    
    @objc func moveToProfile(sender: UIGestureRecognizer) {
        let sender = sender.view as? ChatMemberView
        guard let id = sender?.senderID else { return }
        ChatDataManager.getSenderInfoData(chatID: chatID, senderID: id) { data in
              
            let vc = ChatRoomProfileVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.senderInfo = data
            vc.chatID = self.chatID
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Helpers
    
    func menuItemGesture() {
        let seePostGesture = UITapGestureRecognizer(target: self, action: #selector(moveToPost))
        seePostGesture.numberOfTouchesRequired = 1
        menuItemStackView.arrangedSubviews.first!.addGestureRecognizer(seePostGesture)
        
        let leaveRoomGesture = UITapGestureRecognizer(target: self, action: #selector(leaveRoomAction))
        leaveRoomGesture.numberOfTouchesRequired = 1
        menuItemStackView.arrangedSubviews.last!.addGestureRecognizer(leaveRoomGesture)
        
    }
    
  
    func configureMenu() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        menuItemStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        if postData?.writer?.documentID == currentUser {
            self.menuItemStackView.addArrangedSubview(ChatMenuItem(itemImage: UIImage(systemName: "doc.text")!, itemTitle: "모임글 보기"))
            self.menuItemStackView.addArrangedSubview(ChatMenuItem(itemImage: UIImage(systemName: "multiply.circle")!, itemTitle: "모임 종료하기"))
            self.menuItemGesture()
        } else {
            self.menuItemStackView.addArrangedSubview(ChatMenuItem(itemImage: UIImage(systemName: "doc.text")!, itemTitle: "모임글 보기"))
            self.menuItemStackView.addArrangedSubview(ChatMenuItem(itemImage: UIImage(systemName: "arrowshape.turn.up.backward.circle")!, itemTitle: "나가기"))
            self.menuItemGesture()
        }
    }
    
    func configure() {
        
        configureMenu()
        PostDataManager.getPostData(byID: self.postID) { post in
            guard let writer = post.writer else { return }
            
            self.postData = post
            self.emojiLabel.text = post.emoji
            self.titleLabel.text = post.title
            self.meetingTimeLabel.text = self.getMeetingTime(post.date, post.duration)
            
            UserDataManager.getUserData(byReference: writer) { data in
                self.gradeBugtton.getGrade(.tableCell, data.birth)
            }
            guard let chat = post.chat else { return }
            ChatDataManager.getChattingData(byReference: chat) { data in
                var memberID = [writer.documentID]
                let nickname = data.nickname
                guard let currentUser = Auth.auth().currentUser?.uid else { return }
                
                if memberID[0] != currentUser {
                    memberID.append(currentUser)
                }
                
                let member = data.member
                member.filter { !memberID.contains($0) }.forEach { memberID.append($0) }
                
                self.memberListStackView.subviews.forEach {
                    $0.removeFromSuperview()
                }
                
                for member in memberID {
                    UserDataManager.getUserData(byID: member) { data in
                        let emoji = data.emoji
                        let memberItem = ChatMemberView(emoji: emoji,
                                                        nickname: nickname[member] as? String ?? "",
                                                        writerType: member == writer.documentID ? .writer : .attender,
                                                        memberType: member == currentUser ? .me : .attender,
                                                        sender: member)
                         
                        self.memberListStackView.insertArrangedSubview(memberItem, at: member == writer.documentID ? 0 : member == currentUser ? 1 : self.memberListStackView.subviews.count)
                        let memberProfileGesture = UITapGestureRecognizer(target: self, action: #selector(self.moveToProfile(sender:)))
                        memberProfileGesture.numberOfTouchesRequired = 1
                        self.memberListStackView.arrangedSubviews.forEach {
                            $0.addGestureRecognizer(memberProfileGesture)
                        }
                    }
                }
            }
        }
    }

}

extension ChatRoomMenuVC {
    func configureUI() {
        binding()
        layout()
    }
    func binding() {
        
    }
    
    func layout() {
        view.addSubview(topView)
        view.addSubview(memberHeaderView)
        view.addSubview(memberListStackView)
        view.addSubview(menuItemStackView)
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(Device.widthScale(287))
            $0.height.equalTo(Device.heightScale(90))
        }
        memberHeaderView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalTo(Device.widthScale(287))
            $0.height.equalTo(Device.heightScale(45))
        }
        memberListStackView.snp.makeConstraints {
            $0.top.equalTo(memberHeaderView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalTo(Device.widthScale(287))
        }
        
        menuItemStackView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(Device.heightScale(433))
            $0.leading.equalToSuperview()
            $0.width.equalTo(Device.widthScale(287))
            
        }
    }
}
