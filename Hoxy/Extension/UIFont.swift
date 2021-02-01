//
//  UIFont.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit

extension UIFont {
    public enum FontType: String {
        case bold = "Bold"
        case medium = "Medium"
        case regular = "Regular"
        case semiBold = "SemiBold"
        case light = "Light"
    
    }

    static func BasicFont(_ type: FontType, size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-\(type.rawValue)", size: size)!
    }
    
    
    
}
