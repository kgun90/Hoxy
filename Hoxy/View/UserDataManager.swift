//
//  UserDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/04.
//

import UIKit
import Firebase

protocol UserDataManagerDelegate {
    func getUserData(_ userData: MemberModel)
}

struct UserDataManager {
    var delegate: UserDataManagerDelegate?
    
    func requestUserData() {
        if let user = Auth.auth().currentUser?.uid  {
            set.fs.collection(set.Table.member).document(user).getDocument { (document, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let data = document?.data() {
                        let userData = MemberModel(
                            birth: data["birth"] as! Int,
                            city: data["city"] as! String,
                            email: data["email"] as! String,
                            emoji: data["emoji"] as! String,
                            exp: data["exp"] as! Int,
                            location: data["location"] as? GeoPoint,
                            participation: data["participation"] as! Int,
                            phone: data["phone"] as! String,
                            town: data["town"] as! String,
                            uid: data["uid"] as! String
                        )
                        self.delegate?.getUserData(userData)
                    }
                   
                  
                }
            }
        }
    }
}
