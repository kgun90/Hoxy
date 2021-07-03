//
//  MyMessageCell.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/25.
//

import UIKit

class MyMessageCell: UITableViewCell {
    @IBOutlet weak var contentFrameVeiw: UIView!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var chatData : ChatModel? {
        didSet { configure() }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        contentFrameVeiw.layer.cornerRadius = 8
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        chatLabel.text = nil
        dateLabel.text = nil
        
        updateLayout()
    }
    
    func updateLayout(){
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func configure() {
        guard let data = chatData else { return }
        
        chatLabel.text = data.content
        dateLabel.text = data.date.hhmm
    }
}
