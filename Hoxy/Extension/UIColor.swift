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
    class var meetingTimeOrange: UIColor { #colorLiteral(red: 0.9607843137, green: 0.5803921569, blue: 0.3019607843, alpha: 1) }
    class var labelGray: UIColor { #colorLiteral(red: 0.537254902, green: 0.5725490196, blue: 0.6039215686, alpha: 1) }
    class var hashtagBlue: UIColor { #colorLiteral(red: 0.05098039216, green: 0.5490196078, blue: 1, alpha: 1) }
   
}
