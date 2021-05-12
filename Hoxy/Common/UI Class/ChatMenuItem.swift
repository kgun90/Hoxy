//
//  ChatMenuItem.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/24.
//

import UIKit

class ChatMenuItem: UIView {
    
    init(itemImage: UIImage, itemTitle: String) {
        super.init(frame: .zero)
        let itemImageView = UIImageView().then {
            $0.image = itemImage
            $0.tintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        }
        let itemTitleLabel = UILabel().then {
            $0.font = .BasicFont(.regular, size: 18)
            $0.textColor = .black
            $0.text = itemTitle
        }
        snp.makeConstraints {
            $0.width.equalTo(Device.widthScale(286))
            $0.height.equalTo(Device.heightScale(50))
            
        }
        backgroundColor = .white
        addSubview(itemImageView)
        addSubview(itemTitleLabel)
        
        itemImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(18))
            $0.width.equalTo(Device.widthScale(24))
            $0.height.equalTo(Device.heightScale(24))
        }
        itemTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(itemImageView.snp.trailing).offset(Device.widthScale(8))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
