//
//  AppDelegate.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/21.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        return true
    }
 
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: MessagingDelegate {
//    Token 받기
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

          let dataDict:[String: String] = ["token": fcmToken ?? ""]
          NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
          // TODO: If necessary send token to application server.
          // Note: This callback is fired at each app startup and whenever a new token is generated. 
        }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
//  앱이 켜져있는 상태에서 수신
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
        completionHandler([.alert, .badge, .sound])
    }
//    앱이 꺼져있는 상태에서 수신
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let chatID = userInfo["chattingId"] as? String ?? ""
      
        self.moveToChat(id: chatID)
        
        completionHandler()
    }

    func moveToChat(id: String) {
        if let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window {
            let tabBarController = TabBarController()
            tabBarController.selectedIndex = 2
            tabBarController.isFromNotification = true
            tabBarController.uid = id
            
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
//        if let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window {
//                if let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController {
//                    if let tabBarController = rootViewController as? TabBarController {
//                        tabBarController.selectedIndex = 2
//                        tabBarController.isFromNotification = true
//                        tabBarController.uid = id
//
//                        window.rootViewController = tabBarController
//                        window.makeKeyAndVisible()
//                    }
//                } else {
//                    let tabBarController = UIStoryboard(name: "main", bundle: .main).instantiateViewController(identifier: "TabBarController") as? TabBarController
//                    tabBarController?.selectedIndex = 2
//                    tabBarController?.isFromNotification = true
//                    tabBarController?.uid = id
//
//                    window.rootViewController = tabBarController
//                    window.makeKeyAndVisible()
//                }
//            }
//    }
}

