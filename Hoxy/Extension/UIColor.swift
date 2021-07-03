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
    class var mainBackground: UIColor { #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)}
    class var mainYellow: UIColor { #colorLiteral(red: 0.9607843137, green: 0.8745098039, blue: 0.3019607843, alpha: 1) }
    class var meetingTimeOrange: UIColor { #colorLiteral(red: 0.9607843137, green: 0.5803921569, blue: 0.3019607843, alpha: 1) }
    class var labelGray: UIColor { #colorLiteral(red: 0.537254902, green: 0.5725490196, blue: 0.6039215686, alpha: 1) }
    class var backgroundGray: UIColor { .init(hex: 0xF7F7F7, alpha: 1) }
    class var hashtagBlue: UIColor { #colorLiteral(red: 0.05098039216, green: 0.5490196078, blue: 1, alpha: 1) }
    class var validGreen: UIColor { #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) }
    class var validRed: UIColor { #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) }
    class var disabledGray: UIColor { #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1) }

}
