//
//  ChatRoomProfileVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/19.
//

import UIKit
import Firebase

class ChatRoomProfileVC: UIViewController {
    // MARK: - Properties
    lazy var dismissButton = UIButton().then {
        $0.setImage(UIImage(systemName: "multiply"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    
    lazy var moreButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(barButtonAction), for: .touchUpInside)
    }
    
    lazy var profileView = UIView().then {
        $0.backgroundColor = .clear
        
        $0.addSubview(locationLabel)
        $0.addSubview(nicknameLabel)
        $0.addSubview(gradeButton)
        $0.addSubview(expTitleLabel)
        
        locationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Device.widthScale(33))
            $0.top.equalToSuperview().offset(Device.heightScale(31))
        }
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(locationLabel.snp.leading)
            $0.top.equalTo(locationLabel.snp.bottom).offset(Device.heightScale(1))
        }
        gradeButton.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(Device.widthScale(5))
            $0.bottom.equalTo(nicknameLabel.snp.bottom)
            $0.width.equalTo(Device.widthScale(28))
            $0.height.equalTo(Device.heightScale(14))
        }
        expTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(locationLabel.snp.leading)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(Device.heightScale(11))
        }
    }
    
    lazy var locationLabel = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 14)
        $0.textColor = .black
    }
    
    lazy var nicknameLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 22)
        $0.textColor = .black
    }
    
    let gradeButton = GradeButton(mode: .tableCell)
    
    lazy var expTitleLabel = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 14)
        $0.textColor = .black
        $0.text = "인연지수"
    }
   
    lazy var emojiLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 160)
    }
    
    lazy var attendCountLabel = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 12)
        $0.textColor = .black
    }

    let profileBackTop = ProfileBackTop(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Device.heightScale(230)))
    let profileBackBottom = ProfileBackBottom(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Device.heightScale(430)))
    
    var userID = ""
    var nickname = ""
    var postID = ""
    var chatID = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(hex: 0xdddddd, alpha: 0.1)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        profileDataSet()
        layout()
    }
    
    
    // MARK: - Selectors
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func barButtonAction() {
        let block = UIAlertAction(title: "이 사용자와 만나지 않기", style: .default) { (action) in
            self.blockAction()
        }
        presentAlert(isCancelActionIncluded: true, preferredStyle: .actionSheet, with: block)
    }
    
    // MARK: - Helpers
    func blockAction() {
        let me = set.fs.collection(set.Table.member).document(Auth.auth().currentUser!.uid)
        let user = set.fs.collection(set.Table.member).document(userID)
        let chatting = set.fs.collection(set.Table.chatting).document(chatID)
        
        let blockedData = BlockModel(user: me, date: Date(), chatting: chatting, pair: nil, active: false)
        
        let ban = set.fs.collection(set.Table.member).document(user.documentID)
            .collection("ban").addDocument(data: blockedData.toDic() as [String : Any])
        
       
        let blockData = BlockModel(user: user, date: Date(), chatting: chatting, pair: ban, active: true)
        
        set.fs.collection(set.Table.member).document(me.documentID).collection("ban").addDocument(data: blockData.toDic() as [String : Any])
    }
    
    func layout() {
        view.addSubview(profileBackTop)
        view.addSubview(profileBackBottom)
        view.addSubview(dismissButton)
        view.addSubview(moreButton)
        view.addSubview(profileView)
        view.addSubview(emojiLabel)
        view.addSubview(attendCountLabel)
        
        profileBackTop.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(230))
        }
        profileBackBottom.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(430))
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.navigationBarHeight)
            $0.leading.equalToSuperview().offset(Device.widthScale(20))
            $0.height.equalTo(Device.heightScale(30))
            $0.width.equalTo(Device.widthScale(30))
        }
        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(dismissButton.snp.centerY)
            $0.trailing.equalToSuperview().offset(Device.widthScale(-20))
            $0.width.equalTo(Device.widthScale(30))
            $0.height.equalTo(Device.heightScale(30))
        }
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(90))
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(138))
        }
        emojiLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(210))
            $0.leading.equalToSuperview().offset(Device.widthScale(160))
        }
        attendCountLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(Device.heightScale(-300))
            $0.trailing.equalTo(Device.widthScale(-28))
        }
      
    }
    
    func profileDataSet() {
        set.fs.collection(set.Table.member).document(userID).addSnapshotListener { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    let userData = MemberModel(
                        birth: data["birth"] as! Int,
                        city: data["city"] as! String,
                        email: data["email"] as! String,
                        emoji: data["emoji"] as! String,
                        exp: data["exp"] as! Int,
                        location: data["location"] as? GeoPoint,
                        participation: data["participation"] as! Int,
                        phone: data["phone"] as! String,
                        town: data["town"] as! String,
                        uid: data["uid"] as! String
                    )
                    self.locationLabel.text = userData.town
                    self.gradeButton.getGrade(.tableCell, userData.birth)
                    self.nicknameLabel.text = self.nickname
                    self.emojiLabel.text = userData.emoji
                    self.attendCountLabel.text = "총 모임참여 \(userData.participation)회"
                }
            }
        }
    }
    
 
}
