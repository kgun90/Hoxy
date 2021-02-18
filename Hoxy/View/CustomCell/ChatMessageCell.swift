//
//  ChatMessageCell.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/17.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    lazy var nicknameLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 12)
        $0.textColor = .black
    }
    lazy var emojiLabel = UIButton().then {
        $0.titleLabel?.font = .BasicFont(.regular, size: 30)

    }
//    lazy var emojiLabel = UILabel().then {
//        $0.font = .BasicFont(.regular, size: 30)
//    }
    lazy var contentFrameView = UIView().then {
        $0.backgroundColor = .white
        $0.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    lazy var contentLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 15)
        $0.textColor = .black
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = .clear
        layout() 
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func layout() {
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(contentFrameView)
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(3))
            $0.leading.equalToSuperview().offset(Device.widthScale(49))
        }
        emojiLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(17))
            $0.leading.equalToSuperview().offset(Device.widthScale(11))
        }
        contentFrameView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(Device.heightScale(1))
            $0.leading.equalTo(nicknameLabel.snp.leading)
            $0.width.equalTo(contentLabel.snp.width)
            $0.height.equalTo(contentLabel.snp.height)
        }
    }
}
