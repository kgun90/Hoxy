//
//  LoginButton.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import UIKit

class LoginButton : UIButton {
    init (
        _ text: String,
        titleColor: UIColor,
        backgroundColor: UIColor = .white,
        borderColor: CGColor = UIColor.clear.cgColor
    ) {
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = .BasicFont(.regular, size: 16)
        self.backgroundColor = backgroundColor
        layer.borderColor = borderColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 20
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
