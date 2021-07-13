//
//  AlertDataManager.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/07/05.
//

import Foundation
import Firebase

struct AlertDataManager {
    static func getAlertData(completion: @escaping ([AlertModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Constants.ALERT_COLLECTION.order(by: "date", descending: true).addSnapshotListener { snapshot, error in
//            Constants.ALERT_COLLECTION.addSnapshotListener { snapshot, error in
            var alerts = [AlertModel]()
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            documents.forEach {            
                let alert = AlertModel(dictionary: $0.data())
       
                if alert.uid == uid {
                    alerts.append(alert)
                    completion(alerts)
                }
                
            }
        }
    }
}
