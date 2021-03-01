//
//  ChatMessageCell.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/17.
//

import UIKit

class ChatMessageCell: UITableViewCell {
   
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentFrameView: UIView!
    
    @IBOutlet weak var messageCellStackView: UIStackView!
    var senderID = ""
    var senderNickname = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentFrameView.layer.cornerRadius = 8
        contentView.backgroundColor = .mainBackground
  
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.text = nil
        nicknameLabel.isHidden = false
        emojiButton.isHidden = false
        contentFrameView.backgroundColor = nil
      
        updateLayout()
    }

    func updateLayout(){
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
