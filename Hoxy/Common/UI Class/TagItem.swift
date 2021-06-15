//
//  TagItem.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/12.
//

import UIKit

class TagItem: UIView {
    let tagStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 10
    }
    let tagTitle = UILabel()
    let tagButton = RemoveButton()
    
    init(_ title: String, _ titleColor: UIColor = .white, _ backgroundColor: UIColor = .hashtagBlue,  button: Bool = false) {
        super.init(frame: .zero)
        
     
        self.backgroundColor = backgroundColor
        
        tagTitle.text = title
        tagTitle.textColor = titleColor
        
        addSubview(tagStackView)
        tagStackView.addArrangedSubview(tagTitle)
        
        snp.makeConstraints {
            $0.height.equalTo(Device.heightScale(30))
        }
        
        tagStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(10))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-10))
        }
        
        tagButton.setImage(UIImage(systemName: "multiply"), for: .normal)
        tagButton.tintColor = .white
       
        if button {
            tagStackView.addArrangedSubview(tagButton)
            tagButton.snp.makeConstraints {
                $0.width.equalTo(Device.widthScale(16))
                $0.height.equalTo(Device.heightScale(13.5))
            }
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RemoveButton: UIButton {
    var title: String?
    var count: Int?
}
