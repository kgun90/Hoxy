//
//  AlertItemTableCell.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/20.
//

import UIKit

class AlertItemTableCell: UITableViewCell {
    @IBOutlet weak var lblEmoji: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var data: AlertModel? {
        didSet { configure() }
    }
       
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblEmoji.text = nil
        lblTitle.text = nil
        lblMessage.text = nil
        lblDate.text = nil
      
        updateLayout()
    }

    func updateLayout(){
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setTitle(_ nickName: String) {
        let title = lblTitle.text ?? "title"
        lblTitle.attributedText = title.attributedText(withString: title, boldString: nickName, font: .BasicFont(.light, size: 15))
    }
    
    func configure() {
        guard let data = data else { return }
        
        lblEmoji.text = data.emoji
        lblTitle.text = data.title
        lblMessage.text = data.content
        lblDate.text = data.date.relativeTime_abbreviated
    }
}
