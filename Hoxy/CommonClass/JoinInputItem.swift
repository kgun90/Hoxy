//
//  JoinInputItem.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/24.
//

import UIKit

class JoinInputItem: UIView {
    let tf = UITextField()
    let descriptionLabel = UILabel()
    init( _ headText: String,
          _ placeholder: String,
          _ secureTextType: Bool = false,
          _ descriptionText: String = ""
    ) {
        super.init(frame: .zero)        
        
        let itemLabel = UILabel()
        itemLabel.text = headText
        itemLabel.font = .BasicFont(.medium, size: 14)
        itemLabel.textColor = .black
        
        tf.placeholder = placeholder
        tf.font = .BasicFont(.medium, size: 14)
        tf.isSecureTextEntry = secureTextType
        tf.autocapitalizationType = .none
   
        descriptionLabel.text = descriptionText
        descriptionLabel.font = .BasicFont(.medium, size: 10)
        descriptionLabel.textColor = UIColor(hex: 0x918dff)
        
        addSubview(itemLabel)
        addSubview(tf)
        addSubview(descriptionLabel)
        
        itemLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(25))
            $0.height.equalTo(17)
        }
        tf.snp.makeConstraints {
            $0.top.equalTo(itemLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview().offset(Device.widthScale(32))
            $0.width.equalTo(Device.widthScale(300))
            $0.height.equalTo(Device.heightScale(20))
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(tf.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(Device.widthScale(32))
            $0.height.equalTo(Device.heightScale(12))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
