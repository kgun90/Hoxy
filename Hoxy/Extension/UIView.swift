//
//  UIView.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/30.
//

import UIKit

extension UIView {
    struct BorderOptions: OptionSet {
        let rawValue: Int

        static let top = BorderOptions(rawValue: 1 << 0)
        static let left = BorderOptions(rawValue: 1 << 1)
        static let bottom = BorderOptions(rawValue: 1 << 2)
        static let right = BorderOptions(rawValue: 1 << 3)
        
        static let horizontal: BorderOptions = [.left, .right]
        static let vertical: BorderOptions = [.top, .bottom]
    }
    
    func addBorder(toSide options: BorderOptions, color: UIColor, borderWidth width: CGFloat, circle: Bool = false) {
            // options에 .top이 포함되어있는지 확인
            if options.contains(.top) {
                // 이미 해당 사이드에 경계선이 있는지 확인하고, 있으면 제거
                if let exist = layer.sublayers?.first(where: { $0.name == "top" }) {
                    exist.removeFromSuperlayer()
                }
                let border: CALayer = CALayer()
                border.borderColor = color.cgColor
                border.name = "top"
                // 현재 UIView의 frame 정보를 통해 경계선이 그려질 레이어의 영역을 지정
                border.frame = CGRect(
                    x: 0, y: 0,
                    width: frame.size.width, height: width)
                border.borderWidth = width
                // 현재 그려지고 있는 UIView의 layer의 sublayer중에 가장 앞으로 추가해줌
                let index = layer.sublayers?.count ?? 0
                layer.insertSublayer(border, at: UInt32(index))
            }
        if options.contains(.bottom) {
            if let exist = layer.sublayers?.first(where: { $0.name == "bottom" }) {
                exist.removeFromSuperlayer()
            }
            let border: CALayer = CALayer()
            border.borderColor = color.cgColor
            border.name = "bottom"
            border.frame = CGRect(
                x: 0, y: frame.size.height - width,
                width: frame.size.width, height: width)
            border.borderWidth = width
            
            let index = layer.sublayers?.count ?? 0
            layer.insertSublayer(border, at: UInt32(index))
        }
        if options.contains(.left) {
            if let exist = layer.sublayers?.first(where: { $0.name == "left" }) {
                exist.removeFromSuperlayer()
            }
            let border: CALayer = CALayer()
            border.borderColor = color.cgColor
            border.name = "left"
            border.frame = CGRect(
                x: 0, y: 0,
                width: width, height: frame.size.height)
            border.borderWidth = width
            
            let index = layer.sublayers?.count ?? 0
            layer.insertSublayer(border, at: UInt32(index))
        }
        
        if options.contains(.right) {
            if let exist = layer.sublayers?.first(where: { $0.name == "right" }) {
                exist.removeFromSuperlayer()
            }
            let border: CALayer = CALayer()
            border.borderColor = color.cgColor
            border.name = "right"
            border.frame = CGRect(
                x: frame.size.width - width, y: 0,
                width: width, height: frame.size.height)
            border.borderWidth = width
            
            let index = layer.sublayers?.count ?? 0
            layer.insertSublayer(border, at: UInt32(index))
        }
    }
    
    func removeBorder(toSide options: BorderOptions) {
        if options.contains(.top),
        let border = layer.sublayers?.first(where: { $0.name == "top" }) {
            border.removeFromSuperlayer()
        }
        if options.contains(.bottom),
        let border = layer.sublayers?.first(where: { $0.name == "bottom" }) {
            border.removeFromSuperlayer()
        }
    }
    
    func loadView(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    var mainView: UIView? {
        return subviews.first
    }
    

}
