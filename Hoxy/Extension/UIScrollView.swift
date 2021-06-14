//
//  UIScrollView.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/14.
//

import UIKit

public enum ScrollDirection {
    case top
    case center
    case bottom
    case left
    case right
}

public extension UIScrollView {

    func scroll(to direction: ScrollDirection) {

        DispatchQueue.main.async {
            switch direction {
            case .top:
                self.scrollToTop()
            case .center:
                self.scrollToCenter()
            case .bottom:
                self.scrollToBottom()
            case .left:
                self.scrollToLeft()
            case .right:
                self.scrollToRight()
            }
        }
    }

    private func scrollToTop() {
        setContentOffset(.zero, animated: true)
    }

    private func scrollToCenter() {
        let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2)
        setContentOffset(centerOffset, animated: true)
    }

    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
    private func scrollToLeft() {
        setContentOffset(.zero, animated: true)
    }
    
    private func scrollToRight() {
        let rightOffset = CGPoint(x: contentSize.width - bounds.size.width + contentInset.right, y: 0)
        if(rightOffset.x > 0) {
            setContentOffset(rightOffset, animated: true)
        }
    }
}
