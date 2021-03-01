//
//  MyMessageTableViewCell.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/25.
//

import UIKit

class MyMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var contentFrameVeiw: UIView!
    @IBOutlet weak var chatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
