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
        $0.text = "메세지가 없습니다."
    }
    
    lazy var meetingTimeLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 14)
        $0.textColor = .meetingTimeOrange
        $0.text = "MeetingTime"
    }
    
    lazy var tagLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 10)
        $0.textColor = .hashtagBlue
        $0.text = "MeetingTime"
    }

    var chatData: ChatListModel? {
        didSet { configure() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chatTitleLabel.text = nil
        meetingPlaceLabel.text = nil
        meetingTimeLabel.text = nil
        tagLabel.text = nil
        chatPreviewLabel.text = "메세지가 없습니다"
        updateLayout()
    }
    
    func updateLayout(){
        self.setNeedsLayout()
        self.layoutIfNeeded()
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
        contentView.addSubview(tagLabel)
        
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
            $0.width.equalTo(Device.widthScale(200))
        }
        meetingTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(Device.widthScale(-13))
        }
        tagLabel.snp.makeConstraints {
            $0.leading.equalTo(chatTitleLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(Device.heightScale(-7))
        }
        
    }
    
    func configure() {
        guard let chatData = chatData else { return }
        
        PostDataManager.getPostData(byReference: chatData.chat.post) { data in
            self.chatTitleLabel.text = data.title
            self.meetingPlaceLabel.text = data.town
            self.meetingTimeLabel.text = "".getMeetingTime(data.start)
            self.tagLabel.text = "#" + data.tag.joined(separator: "#")
        }
        
        var chats = [ChatModel]()
        
        ChatDataManager.getChatData(byId: chatData.id) { data in
            chats = data.sorted(by: { $0.date < $1.date })
            
            let senderID = chats[chats.count-1].sender.documentID
            
            ChatDataManager.getSenderInfoData(chatID: chatData.id, senderID: senderID) { data in
                let previewText = data.nickname + ": " + chats[chats.count-1].content
               
                self.chatPreviewLabel.attributedText = previewText.attributedText(withString: previewText, boldString: data.nickname, font: .BasicFont(.regular, size: 12), boldFont: .BasicFont(.semiBold, size: 12))
            }
        }
    }
}
