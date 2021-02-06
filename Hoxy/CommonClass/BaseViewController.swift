//
//  BaseViewController.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/29.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Properties
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        // Background Color
        self.view.backgroundColor = .mainBackground
    }
    // MARK: - Selectors
    
    // MARK: - Helpers
    func configureUI() {
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainYellow
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isTranslucent = true
        
//        let backButton = UIBarButtonItem().then {
////            $0.image = UIImage(systemName: "arrow.left")
//            $0.title = ""
//            $0.style = .plain
//            $0.target = self
////            $0.action = #selector(backButtonAction)
//        }
//        navigationItem.backBarButtonItem = backButton
        
    }
//    @objc func backButtonAction() {
////        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
////        navigationController?.popToRootViewController(animated: true)
//
//        let vc = TabBarController()
//        if let window = UIApplication.shared.windows.first {
//            window.rootViewController = vc
//            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
//        } else {
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
}
