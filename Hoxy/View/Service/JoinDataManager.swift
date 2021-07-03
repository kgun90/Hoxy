//
//  JoinDataManager.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/20.
//

import Foundation
import Firebase
import CoreLocation

protocol AuthDataDelegate {
    func phoneNumAuth(_ veriID: String)
    func validAuth(_ error: String, _ uid: String)
}

protocol JoinDelegate {
    func joinAction(_ error: String)
}

struct JoinDataManager {
    var authDelegate: AuthDataDelegate?
    var joinDelegate: JoinDelegate?
    
    func phoneNumberAuthentication(phoneNum: String) {
        let phoneNumber = "+82 \(String(Array(phoneNum)[1...]))"
        Auth.auth().languageCode = "kr"

        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (id, error) in
            if let e = error {
                print("ID Get Error \(e.localizedDescription)")
                self.authDelegate?.phoneNumAuth("")
                return
            }
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
    
    func joinProcess(_ joinInfo: JoinModel, _ currentLatLon: GeoPoint) {
        Auth.auth().currentUser?.updateEmail(to: joinInfo.email, completion: { (error) in
            if let e = error {
                print(e.localizedDescription)
                joinDelegate?.joinAction(e.localizedDescription)
            }
        })
        Auth.auth().currentUser?.updatePassword(to: joinInfo.pass, completion:  { (error) in
            if let e = error {
                print(e.localizedDescription)
                joinDelegate?.joinAction(e.localizedDescription)
            }
        })
        let emoji: String = ""
        
        Constants.MEMBER_COLLECTION.document(joinInfo.uid).setData([
            "birth": joinInfo.age,
            "city": joinInfo.city,
            "email": joinInfo.email,
            "emoji": emoji.randomEmoji(),
            "exp": 50,
            "location": currentLatLon,
            "participation": 0,
            "phone": joinInfo.phone,
            "town": joinInfo.town,
            "uid": joinInfo.uid
        ])
        joinDelegate?.joinAction("")
    }
}
