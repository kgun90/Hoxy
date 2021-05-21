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
    
    let emailDesText = Observable("로그인, 비밀번호 찾기 등에 사용됩니다.")
    let passDesText = Observable("특수문자는 (! @ # $ % ^ & ? _ ~) 만 가능합니다.")
    let passCheckDesText = Observable("")
    let authDesText = Observable("")
    
    let emailDesColor: Observable<UIColor?> = Observable(#colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1))
    let passDesColor: Observable<UIColor?> = Observable(#colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1))
    let passCheckDesColor: Observable<UIColor?> = Observable(#colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1))
    let authDesColor: Observable<UIColor?> = Observable(#colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1))
    
    let buttonEnable = Observable(false)
    let validButtonEnable = Observable(false)
    let authButtonEnable = Observable(false)
    let authDesVisability = Observable(false)
    
    let buttonColor: Observable<UIColor?> = Observable(.labelGray)
    let validButtonColor: Observable<UIColor?> = Observable(.labelGray)
    let authButtonColor: Observable<UIColor?> = Observable(.labelGray)
    
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
    
    func descriptionEmailText() {
        if self.email == "" {
            emailDesText.value = "로그인, 비밀번호 찾기 등에 사용됩니다."
            emailDesColor.value = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        } else if self.email?.validateEmail() == true {
            emailDesText.value = "올바른 양식입니다"
            emailDesColor.value = .validGreen
        } else {
            emailDesText.value = "양식에 맞게 입력해 주세요"
            emailDesColor.value = .validRed
        }
    }
    
    func descriptionEmailTextEntering() {
        if self.email == "" {
            emailDesText.value = "로그인, 비밀번호 찾기 등에 사용됩니다."
            emailDesColor.value = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        } else if self.email?.validateEmail() == true {
            emailDesText.value = "올바른 양식입니다"
            emailDesColor.value = .validGreen
        } else {
            emailDesText.value = "양식에 맞게 입력해 주세요"
            emailDesColor.value = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        }
    }

    func descriptionPassText() {
        if self.password == "" {
            passDesText.value = "특수문자는 (! @ # $ % ^ & ? _ ~) 만 가능합니다."
            passDesColor.value = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        } else if self.password?.validatePassword() == true {
            passDesText.value = "올바른 양식입니다"
            passDesColor.value = .validGreen
        } else {
            passDesText.value = "양식에 맞게 입력해주세요"
            passDesColor.value = .validRed
        }
    }
    
    func descriptionPassTextEntering() {
        if self.password == "" {
            passDesText.value = "특수문자는 (! @ # $ % ^ & ? _ ~) 만 가능합니다."
            passDesColor.value = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        } else if self.password?.validatePassword() == true {
            passDesText.value = "올바른 양식입니다"
            passDesColor.value = .validGreen
        } else {
            passDesText.value = "양식에 맞게 입력해주세요"
            passDesColor.value = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        }
    }
    
    func descriptionPassCheckText() {
        if self.passCheck == "" {
            passCheckDesText.value = ""
        } else if passAreMatched {
            passCheckDesText.value =  "비밀번호와 일치합니다."
            passCheckDesColor.value = .validGreen
        } else {
            passCheckDesText.value = "입력된 비밀번호와 일치하지 않습니다."
            passCheckDesColor.value = .validRed
        }
    }
    
    func phoneNumValidation() {
        if self.phoneNum?.validatePhoneNum() == true {
            validButtonColor.value = .mainYellow
            validButtonEnable.value = true
        } else {
            validButtonColor.value = .labelGray
            validButtonEnable.value = false
        }
    }
    
    func authNumValidation() {
        if self.authNum?.validateAuthCode() == true {
            authButtonColor.value = .mainYellow
            authButtonEnable.value = true
        } else {
            authButtonColor.value = .labelGray
            authButtonEnable.value = false
        }
    }
    
    func buttonEnableCheck() {
        if formIsValid {
            buttonEnable.value = true
            buttonColor.value = .mainYellow
        } else {
            buttonEnable.value = false
            buttonColor.value = .labelGray
        }
    }
    
    func descriptionAuthText() {
        self.authDesVisability.value = false

        if self.validAuth == true {
            self.authDesText.value = "인증되었습니다."
            self.authDesColor.value = .validGreen
        } else {
            self.authDesText.value = "인증번호를 올바르게 입력 바랍니다."
            self.authDesColor.value = .validRed            
        }
    }
    
    func passwordInitialize() {
        passText.value = ""
        passDesText.value = ""
        
    }
}
