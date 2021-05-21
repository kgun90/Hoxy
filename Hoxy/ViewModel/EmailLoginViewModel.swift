//
//  EmailJoinViewModel.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/10.
//

import Foundation
import UIKit.UIColor

protocol AutenticationProtocol {
    var formIsValid: Bool { get }
}

struct EmailLoginViewModel {
    var email: String?
    var password: String?
    
    let emailText = Observable("")
    let passText = Observable("")
    
    let emailDesText = Observable("")
    let passDesText = Observable("")
    
    let emailDesColor: Observable<UIColor?> = Observable(nil)
    let passDesColor: Observable<UIColor?> = Observable(nil)
    
    let buttonEnable = Observable(false)
    let buttonColor: Observable<UIColor?> = Observable(#colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1))
    
    var formIsValid: Bool {
        return self.email?.validateEmail() == true && self.password?.validatePassword() == true
    }

    func descriptionEmailText() {
        if self.email == "" {
            emailDesText.value = ""
        } else if self.email?.validateEmail() == true {
            emailDesText.value = "올바른 양식입니다"
            emailDesColor.value = .validGreen
        } else {
            emailDesText.value = "양식에 맞게 입력해주세요"
            emailDesColor.value = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        }
    }

    func descriptionPassText() {
        if self.password == "" {
            passDesText.value = ""
        } else if self.password?.validatePassword() == true {
            passDesText.value = "올바른 양식입니다"
            passDesColor.value = .validGreen
        } else {
            passDesText.value = "양식에 맞게 입력해주세요"
            passDesColor.value = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        }
    }
    
    func buttonEnableCheck() {
        if formIsValid {
            buttonEnable.value = true
            buttonColor.value = .mainYellow
        } else {
            buttonEnable.value = false
            buttonColor.value = #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1)
        }
    }
    
     func passwordInitialize() {
        passText.value = ""
        passDesText.value = ""
        
    }
}
