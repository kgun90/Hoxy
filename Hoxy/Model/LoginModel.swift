//
//  LoginModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/27.
//

import UIKit

struct LoginModel {
    var email: String = ""
    var pass: String = ""
    var phone: String = ""
    var city: String = ""
    var town: String = ""
    var uid: String = ""
    var age: Int = 0
}

struct DefaultSetModel {
    var text: String = ""
    var color: UIColor = .labelGray
    var visability: Bool = false
}

public enum InputMode {
    case realtime
    case once
}

struct EmailModel {
    var email: String = ""
    var pass: String = ""
    var valid: Bool {
        return email.validateEmail() && pass.validatePassword()
    }
}
