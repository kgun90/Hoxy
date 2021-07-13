//
//  TabBarController.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit
import Then

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    let home = HomeVC()
    let unknown = AlertVC()
    let chat = ChatListVC()
    let myPage = MyPageVC()
    
    let homeItem = UITabBarItem().then{
        $0.image = UIImage(systemName: "house")
        $0.tag = 0
    }
    
    let unknownItem = UITabBarItem().then{
        $0.image = UIImage(systemName: "bell")
        $0.tag = 0
    }
    
    let chatItem = UITabBarItem().then{
        $0.image = UIImage(systemName: "message")
        $0.tag = 0
    }
    
    let myPageItem = UITabBarItem().then{
        $0.image = UIImage(systemName: "person")
        $0.tag = 0
    }
    
    var isFromNotification = false
    var uid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeNetworkController = UINavigationController(rootViewController: home)
        let unknownNetoworkController = UINavigationController(rootViewController: unknown)
        let chatNetworkController = UINavigationController(rootViewController: chat)
        let myPageNetworkController = UINavigationController(rootViewController: myPage)
        
        homeNetworkController.tabBarItem = homeItem
        unknownNetoworkController.tabBarItem = unknownItem
        chatNetworkController.tabBarItem = chatItem
        myPageNetworkController.tabBarItem = myPageItem
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = .mainYellow
        
        self.viewControllers = [homeNetworkController, unknownNetoworkController, chatNetworkController, myPageNetworkController]
        self.delegate = self
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        if isFromNotification {
            chat.isPushNotification = isFromNotification
            chat.chatID = self.uid
            Log.any(uid)
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

          guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
          }

        
          if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.1, options: [.transitionCrossDissolve], completion: nil)
          }

          return true
      }
}
