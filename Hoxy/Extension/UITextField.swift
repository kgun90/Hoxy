//
//  UITextField.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/25.
//

import UIKit

extension UITextField {
    func addUnderLine(color: UInt = 0x000000) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-1, width: self.frame.width, height: 1)
        border.backgroundColor = UIColor.init(hex: color, alpha: 1).cgColor
        borderStyle = .none
        layer.addSublayer(border)
    }
    
    func setDatePicker(target: Any, selector: Selector) {
        let SCwidth = self.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: SCwidth, height: 216))
        datePicker.datePickerMode = .date
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: SCwidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
        
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
        
    }
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
 
}
