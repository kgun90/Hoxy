//
//  UITextField.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/25.
//

import UIKit

extension UITextField {
    func addUnderLine() {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-1, width: self.frame.width, height: 1)
        border.backgroundColor = UIColor.black.cgColor
        borderStyle = .none
        layer.addSublayer(border)
    }
}
