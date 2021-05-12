//
//  ProfileBackBottom.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/26.
//

import UIKit

class ProfileBackBottom : UIView {
    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        self.createPolygon(rect)
        UIColor.mainYellow.setFill()
        path.fill()
    }
    
    func createPolygon(_ rect: CGRect ) {
        path = UIBezierPath()

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + Device.heightScale(50)))

        path.close()
    }
}
