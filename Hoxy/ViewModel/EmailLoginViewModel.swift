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
    
    let observableEmail = Observable("")
    let observablePassword = Observable("")
    
    let emailDescriptionLabel = Observable("")
    let passwordDescriptionLabel = Observable("")
    
    let emailDC: Observable<UIColor?> = Observable(nil)
    let passDC: Observable<UIColor?> = Observable(nil)
    
    let buttonEnable = Observable(false)
    let buttonColor: Observable<UIColor?> = Observable(#colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1))
    
    var formIsValid: Bool {
        return self.email?.validateEmail() == true && self.password?.validatePassword() == true
    }

    func descriptionEmailText() {
        if self.email == "" {
            emailDescriptionLabel.value = ""
        } else if self.email?.validateEmail() == true {
            emailDescriptionLabel.value = "올바른 양식입니다"
            emailDC.value = .green
        } else {
            emailDescriptionLabel.value = "양식에 맞게 입력해주세요"
            emailDC.value = .red
        }
    }

    func descriptionPassText() {
        if self.password == "" {
            passwordDescriptionLabel.value = ""
        } else if self.password?.validatePassword() == true {
            passwordDescriptionLabel.value = "올바른 양식입니다"
            passDC.value = .green
        } else {
            passwordDescriptionLabel.value = "양식에 맞게 입력해주세요"
            passDC.value = .red
        }
    }
    
    func buttonEnableCheck() {
        if self.email?.validateEmail() == true && self.password?.validatePassword() == true {
            buttonEnable.value = true
            buttonColor.value = .mainYellow
        } else {
            buttonEnable.value = false
            buttonColor.value = #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1)
        }
    }
    
     func passwordInitialize() {

        observablePassword.value = ""
        passwordDescriptionLabel.value = ""
        
    }
}
