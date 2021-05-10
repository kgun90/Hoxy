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
    
    var formIsValid: Bool {
        return self.email?.validateEmail() == true && self.password?.validatePassword() == true
    }
}
