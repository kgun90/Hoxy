//
//  AuthPhoneItem.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/25.
//

import UIKit

class AuthPhoneItem: UIView {
    init() {
        super.init(frame: .zero)
        let firstTitle = UILabel()
        let secontTitle = UILabel()
        let firstTF = UITextField()
        let secondTF = UITextField()
        let firstButton = UIButton()
        let secontButton = UIButton()
        
   
        
        secondTF.placeholder = "인증번호 입력"
        
     
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
