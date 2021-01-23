//
//  UIColor.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange
    class var mainBackground: UIColor { UIColor(hex: 0xdddddd, alpha: 1)}
    class var mainYellow: UIColor { #colorLiteral(red: 0.9607843137, green: 0.8745098039, blue: 0.3019607843, alpha: 1) }
   
}
