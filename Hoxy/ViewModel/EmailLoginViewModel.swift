//
//  EmailJoinViewModel.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/10.
//

import Foundation

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
    
    var formIsValid: Bool {
        return self.email?.validateEmail() == true && self.password?.validatePassword() == true
    }
    
    func validation(_ valid: Bool) {
        if valid {
            emailDescriptionLabel.value = "올바른 이메일 주소 양식입니다."
        } else {
            emailDescriptionLabel.value = "올바른 양식으로 입력 바랍니다"
        }
    }
    
    func changeText() {
        self.observableEmail.value = "changed"
    }

    
    func loginCheck() {
        observablePassword.value = ""
    }
}
