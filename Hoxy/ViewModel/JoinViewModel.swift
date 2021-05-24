//
//  JoinViewModel.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/13.
//

import Foundation
import UIKit.UIColor

protocol PasswordCheckProtocol {
    var passAreMatched: Bool { get }
    var formIsValide: Bool { get }
}
struct JoinViewModel {
    var email: String?
    var password: String?
    var passCheck: String?
    var phoneNum: String?
    var authNum: String?
    var validAuth: Bool?
    
    let emailText = Observable("")
    let passText = Observable("")
    let passCheckText = Observable("")
    let phoneNumText = Observable("")
    
    
    let emailDes = Observable(DefaultSetModel())
    let passDes = Observable(DefaultSetModel())
    let passCheckDes = Observable(DefaultSetModel())
    let phoneValidButton = Observable(DefaultSetModel())
    let authDes = Observable(DefaultSetModel())
    let authButton = Observable(DefaultSetModel())
    let moveNextButton = Observable(DefaultSetModel())
        
    
    var passAreMatched: Bool {
        return self.password == self.passCheck
    }
    
    var formIsValid: Bool {
        if self.email?.validateEmail() ?? false,
           self.password?.validatePassword() ?? false,
           self.phoneNum?.validatePhoneNum() ?? false,
           self.authNum?.validateAuthCode() ?? false,
           passAreMatched,
           validAuth ?? false {
            return true
        }
        return false
    }
    
    func descriptionEmailText(_ mode: InputMode) {
        if self.email == "" {
            emailDes.value.text = "로그인, 비밀번호 찾기 등에 사용됩니다."
            emailDes.value.color = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        } else if self.email?.validateEmail() == true {
            emailDes.value.text  = "올바른 양식입니다"
            emailDes.value.color = .validGreen
        } else {
            emailDes.value.text  = "양식에 맞게 입력해 주세요"
            emailDes.value.color = (mode == .realtime ? #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1) : .validRed)
        }
    }
    
    func descriptionPassText(_ mode: InputMode) {
        if self.password == "" {
            passDes.value.text = "특수문자는 (! @ # $ % ^ & ? _ ~) 만 가능합니다."
            passDes.value.color = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        } else if self.password?.validatePassword() == true {
            passDes.value.text = "올바른 양식입니다"
            passDes.value.color = .validGreen
        } else {
            passDes.value.text = "양식에 맞게 입력해주세요"
            passDes.value.color = (mode == .realtime ? #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1) : .validRed)
        }
    }
    
    
    func descriptionPassCheckText() {
        if self.passCheck == "" {
            passCheckDes.value.text = ""
        } else if passAreMatched {
            passCheckDes.value.text =  "비밀번호와 일치합니다."
            passCheckDes.value.color = .validGreen
        } else {
            passCheckDes.value.text = "입력된 비밀번호와 일치하지 않습니다."
            passCheckDes.value.color = .validRed
        }
    }
    
    func phoneNumValidation() {
        if self.phoneNum?.validatePhoneNum() == true {
            phoneValidButton.value.color = .mainYellow
            phoneValidButton.value.visability = true
        } else {
            phoneValidButton.value.color = .labelGray
            phoneValidButton.value.visability = false
        }
    }
    
    func authNumValidation() {
        if self.authNum?.validateAuthCode() == true {
            authButton.value.color = .mainYellow
            authButton.value.visability = true
        } else {
            authButton.value.color = .labelGray
            authButton.value.visability = false
        }
    }
    
    func buttonEnableCheck() {
        if formIsValid {
            moveNextButton.value.visability = true
            moveNextButton.value.color = .mainYellow
        } else {
            moveNextButton.value.visability = false
            moveNextButton.value.color = .labelGray
        }
    }
    
    func descriptionAuthText() {
        self.authDes.value.visability = false

        if self.validAuth == true {
            authDes.value.text = "인증되었습니다."
            authDes.value.color = .validGreen
        } else {
            authDes.value.text = "인증번호를 올바르게 입력 바랍니다."
            authDes.value.color = .validRed
        }
    }
    
    func passwordInitialize() {
        passText.value = ""
        passDes.value.text = ""
        
    }
}
