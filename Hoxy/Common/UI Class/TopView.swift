//
//  TopView.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/24.
//

import UIKit

class TopView: UIView {
    let back = UIButton()
    
    init(_ title: String,
         _ backgroundColor: UIColor = #colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1)
         ) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = .BasicFont(.medium, size: 18)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Device.heightScale(57))
        }
        
        // MARK: - back button setting
     
        back.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        back.tintColor = .black

        addSubview(back)
        back.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Device.widthScale(30))
            $0.top.equalToSuperview().offset(Device.heightScale(60))
            $0.width.equalTo(Device.widthScale(16))
            $0.height.equalTo(Device.heightScale(13.5))
        }
     
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
