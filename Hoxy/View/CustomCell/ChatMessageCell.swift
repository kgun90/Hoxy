//
//  ChatMessageCell.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/17.
//

import UIKit
protocol ChateMessageCellDelegate: AnyObject {
    func showChatUserProfile(senderInfo: SenderInfoModel)
}
class ChatMessageCell: UITableViewCell {
    weak var delegate: ChateMessageCellDelegate?
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var contentFrameView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var messageCellStackView: UIStackView!
    var senderID = ""
    var senderNickname = ""
    var chatID = ""
    
    var chatData : ChatModel? {
        didSet { configure() }
    }
    
    var senderInfo: SenderInfoModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentFrameView.layer.cornerRadius = 8
        self.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chatLabel.text = nil
        nicknameLabel.text = nil
        dateLabel.text = nil
        
        nicknameLabel.isHidden = false
        emojiButton.isHidden = false
      
        updateLayout()
    }

    func updateLayout(){
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    @objc func handleEmojiButton(_ sender: UIButton) {
        delegate?.showChatUserProfile(senderInfo: self.senderInfo!)
    }
    
    func configure() {
        guard let data = chatData else { return }
        
        UserDataManager.getUserData(byReference: data.sender) { member in
            let id = data.sender.documentID

            ChatDataManager.getSenderInfoData(chatID: self.chatID, senderID: id) { data in
                self.senderInfo = data
                self.nicknameLabel.text = data.nickname
            }
            
            self.emojiButton.setTitle(member.emoji, for: .normal)
            self.emojiButton.addTarget(self, action: #selector(self.handleEmojiButton(_:)), for: .touchUpInside)
        }
      
        chatLabel.text = data.content
        dateLabel.text = data.date.hhmm
    }
}
