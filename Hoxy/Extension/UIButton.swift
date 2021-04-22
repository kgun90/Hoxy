//
//  UIButton.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/24.
//

import UIKit

extension UIButton {
    func setRoundedCorners(ratio: Double?) {
        if let r = ratio {
            self.layer.cornerRadius = self.frame.size.width*CGFloat(r) // for specific corner ratio
        } else {
            // circle
            if(self.frame.size.width == self.frame.size.height) {
                self.layer.cornerRadius = self.frame.size.width/2 // for circles
            }
        }
        self.layer.borderWidth = 1
    }
}
