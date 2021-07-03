//
//  BlockUserCell.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/07/03.
//

import UIKit

class BlockUserCell: UITableViewCell {
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var townLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var data: BlockModel? {
        didSet { configure() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        guard let data = data else { return }
        guard let userID = data.user?.documentID else { return }
        
        ChatDataManager.getChattingData(byReference: data.chatting) { data in
            self.nicknameLabel.text = data.nickname[userID] as? String ?? ""
        }
        UserDataManager.getUserData(byReference: data.user) { data in
            self.townLabel.text = data.town
            self.emojiLabel.text = data.emoji
        }
        dateLabel.text = data.date.hhmm
    }
}
