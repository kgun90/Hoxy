//
//  ChatMemeberView.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/23.
//

import UIKit

enum MemberType {
    case me
    case writer
    case attender
}

class ChatMemberView: UIView {
    let emojiButton = UIButton().then {
        $0.titleLabel?.font = .BasicFont(.regular, size: 16)
    }
    let nicknameLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 16)
        $0.textColor = .black
    }

    let meView = UIView().then {
        $0.backgroundColor = .meetingTimeOrange
        $0.layer.cornerRadius = 6
    }
    
    let meLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 8)
        $0.textColor = .white
        $0.text = "나"
    }
    
    let writerIcon = UIImageView().then {
        $0.image = UIImage(systemName: "crown")
        $0.tintColor = .meetingTimeOrange
    }
    
    let badgeStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.spacing = 2
        $0.distribution = .fillProportionally
    }
    
    var sender: String = ""
    
    init(_ emoji: String, _ nickname: String, writerType: MemberType, memberType: MemberType, sender: String) {
        super.init(frame: .zero)
        getMemberData(emoji, nickname, writerType, memberType)
        backgroundColor = .white
       
        self.sender = sender
        
        meView.addSubview(meLabel)
        
        addSubview(emojiButton)
        addSubview(nicknameLabel)
        addSubview(badgeStackView)
        badgeStackView.addArrangedSubview(writerIcon)
        badgeStackView.addArrangedSubview(meView)
       
        
        snp.makeConstraints {
            $0.height.equalTo(Device.heightScale(40))
            $0.width.equalTo(Device.widthScale(200))
        }
        
        emojiButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(23))
        }
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(emojiButton.snp.trailing).offset(Device.widthScale(4))
        }
        badgeStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(Device.widthScale(3))
        }
        
        meView.snp.makeConstraints {
            $0.width.equalTo(Device.widthScale(12))
            $0.height.equalTo(Device.heightScale(12))
        }
        meLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        writerIcon.snp.makeConstraints {
            $0.width.equalTo(Device.widthScale(12))
            $0.height.equalTo(Device.heightScale(12))
        }
    }
    
    func getMemberData(_ emoji: String, _ nickname: String, _ writerType: MemberType, _ memberType: MemberType) {
        emojiButton.setTitle(emoji, for: .normal)
//        emojiButton.text = emoji
        nicknameLabel.text = nickname
        if writerType == .writer {
            writerIcon.isHidden = false
        } else {
            writerIcon.isHidden = true
        }
        
        if memberType == .me {
            meView.isHidden = false
        } else {
            meView.isHidden = true
        }
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
