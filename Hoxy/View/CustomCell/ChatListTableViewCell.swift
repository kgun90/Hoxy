//
//  ChatListTableViewCell.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/15.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    lazy var chatTitleLabel = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 16)
        $0.textColor = .black
        $0.text = "Title"
    }
    
    lazy var meetingPlaceLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 12)
        $0.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        $0.text = "meeting place"
    }
    
    lazy var chatPreviewLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 12)
        $0.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        $0.text = "User: TextPreview"
    }
    
    lazy var meetingTimeLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 14)
        $0.textColor = .meetingTimeOrange
        $0.text = "MeetingTime"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layout() {
        contentView.addSubview(chatTitleLabel)
        contentView.addSubview(meetingPlaceLabel)
        contentView.addSubview(chatPreviewLabel)
        contentView.addSubview(meetingTimeLabel)
        
        chatTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(13))
            $0.leading.equalToSuperview().offset(Device.widthScale(21))
        }
        meetingPlaceLabel.snp.makeConstraints {
            $0.bottom.equalTo(chatTitleLabel.snp.bottom)
            $0.leading.equalTo(chatTitleLabel.snp.trailing).offset(Device.widthScale(2))
        }
        chatPreviewLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(chatTitleLabel.snp.leading)
        }
        meetingTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(Device.widthScale(-13))
        }
        
        
    }
}
