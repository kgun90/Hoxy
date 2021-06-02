//
//  TagListTableViewCell.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/01.
//

import UIKit

class TagListTableViewCell: UITableViewCell {
    lazy var tagLabel = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 16)
        $0.textColor = .black
        $0.text = "Title"
    }
    lazy var countLabel = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 16)
        $0.textColor = .black
        $0.text = "Title"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func layout() {
        contentView.addSubview(tagLabel)
        contentView.addSubview(countLabel)
        
        tagLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(21))
        }
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(Device.widthScale(-15))
        }
    }
}
