//
//  BottomButton.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/24.
//

import UIKit

class BottomButton: UIButton {
    init(_ buttonTitle: String,
         _ buttonBackgroundColor: UIColor = #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1)) {
        super.init(frame: .zero)
        setTitle(buttonTitle, for: .normal)
        titleLabel?.font = .BasicFont(.semiBold, size: 17)
        setTitleColor(.black, for: .normal)
        backgroundColor = buttonBackgroundColor
        titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 15,right: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
