//
//  ChatMemberTableViewCell.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/22.
//

import UIKit

class ChatMemberTableViewCell: UITableViewCell {
    @IBOutlet weak var memberEmoji: UIButton!
    @IBOutlet weak var memberNickname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
