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
    
    let emailText = Observable("")
    let passText = Observable("")
    let passCheckText = Observable("")
    
    let emailDesText = Observable("")
    let passDesText = Observable("")
    let passCheckDesText = Observable("")
    
    let emailDesColor: Observable<UIColor?> = Observable(nil)
    let passDesColor: Observable<UIColor?> = Observable(nil)
    let passCheckDesColor: Observable<UIColor?> = Observable(nil)
    
    let buttonEnable = Observable(false)
    let buttonColor: Observable<UIColor?> = Observable(.labelGray)
    
    var passAreMatched: Bool {
        return self.password == self.passCheck
    }
    
    var formIsValid: Bool {
        return true
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
    
    func descriptionPassCheckText() {
        if self.passCheck == "" {
            passCheckDesText.value = ""
        } else if passAreMatched {
            passDesText.value =  "비밀번호와 일치합니다."
            passDesColor.value = .validGreen
        } else {
            passDesText.value = "입력된 비밀번호와 일치하지 않습니다."
            passDesColor.value = .validRed
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
    
     func passwordInitialize() {
        passText.value = ""
        passDesText.value = ""
        
    }
}
