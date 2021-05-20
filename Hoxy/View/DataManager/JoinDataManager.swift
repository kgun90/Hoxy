//
//  JoinDataManager.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/20.
//

import Foundation
import Firebase

protocol AuthDataDelegate {
    func phoneNumAuth(_ veriID: String)
    func validAuth(_ error: String, _ uid: String)
}

struct JoinDataManager {
    var authDelegate: AuthDataDelegate?
    
    func phoneNumberAuthentication(phoneNum: String) {
        let phoneNumber = "+82 \(String(Array(phoneNum)[1...]))"
//        var veriID = ""
        Auth.auth().languageCode = "kr"

        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (id, error) in
            if let e = error {
                print("ID Get Error \(e.localizedDescription)")
                return
            }
        
//            veriID = id ?? ""
            self.authDelegate?.phoneNumAuth(id ?? "")
        }
    }
    
    func authSubmit(_ veriID: String, _ veriCode: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: veriID, verificationCode: veriCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let e = error {
                print(e.localizedDescription)
                authDelegate?.validAuth(e.localizedDescription, "")
                return
            }
            authDelegate?.validAuth("", authResult?.user.uid ?? "")
        }
    }
}
