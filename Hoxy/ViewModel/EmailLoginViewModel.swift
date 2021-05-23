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
    
    let emailDes = Observable(DefaultSetModel())
    let passDes = Observable(DefaultSetModel())
    let buttonSet = Observable(DefaultSetModel())
        
    var formIsValid: Bool {
        return self.email?.validateEmail() == true && self.password?.validatePassword() == true
    }

    func descriptionEmailText() {
        if self.email == "" {
            emailDes.value.text = ""
        } else if self.email?.validateEmail() == true {
            emailDes.value.text = "올바른 양식입니다"
            emailDes.value.color = .validGreen
        } else {
            emailDes.value.text = "양식에 맞게 입력해주세요"
            emailDes.value.color = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        }
    }

    func descriptionPassText() {        
        if self.password == "" {
            passDes.value.text = ""
        } else if self.password?.validatePassword() == true {
            passDes.value.text = "올바른 양식입니다"
            passDes.value.color = .validGreen
        } else {
            passDes.value.text = "양식에 맞게 입력해주세요"
            passDes.value.color = #colorLiteral(red: 0.568627451, green: 0.5529411765, blue: 1, alpha: 1)
        }
    }
    
    func buttonEnableCheck() {
        if formIsValid {
            buttonSet.value.visability = true
            buttonSet.value.color = .mainYellow
        } else {
            buttonSet.value.visability = false
            buttonSet.value.color = #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1)
        }
    }
    
     func passwordInitialize() {
        passText.value = ""
        passDes.value.text = ""
        
    }
}
