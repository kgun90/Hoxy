//
//  WriteOptionItem.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import UIKit

class WriteOptionItem: UIView {
    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .white

        let title = UILabel().then {
            $0.font = .BasicFont(.semiBold, size: 16)
            $0.text = "\(title) >"
        }
        addSubview(title)
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(Device.widthScale(31))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
