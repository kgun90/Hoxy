//
//  WriteOptionItem.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import UIKit

class WriteOptionItem: UIView {
    let textField = UITextField().then {
        $0.font = .BasicFont(.semiBold, size: 16)
        $0.tintColor = .clear
    }
    init (placeholder: String ) {
        super.init(frame: .zero)
        backgroundColor = .white
        labelSetting(placeholder)
    }
    
    func labelSetting(_ placeHolder: String) {
        
        textField.attributedPlaceholder = NSAttributedString(string: "\(placeHolder) >", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
 
        
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(Device.widthScale(31))
            $0.width.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
