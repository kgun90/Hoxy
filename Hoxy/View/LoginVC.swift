//
//  LoginVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit
import SnapKit
import Then

class LoginVC: UIViewController {
    lazy var logoImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        return iv
    }()
    
    lazy var googleLoginButton = UIButton().then{
        $0.setTitle("구글로 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .BasicFont(.regular, size: 16)
    }
    
    lazy var appleLoginButton = UIButton().then {
        $0.setTitle("애플로 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .BasicFont(.regular, size: 16)
        $0.backgroundColor = .black
    }
    
    lazy var emailLoginButton = UIButton().then {
        $0.setTitle("이메일로 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .BasicFont(.regular, size: 16)
        $0.backgroundColor = .mainYellow
        $0.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }
    
    lazy var joinLabel = UILabel().then {
        $0.text = "처음 오셨나요 HOXY?"
        $0.font = .BasicFont(.semiBold, size: 15)
        $0.textColor = UIColor(hex: 0x7b6b6b)
    }
    
    lazy var joinButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor(hex: 0x004aad), for: .normal)
        $0.titleLabel?.font = .BasicFont(.semiBold, size: 15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
    }
    
    func layout() {
        view.addSubview(logoImage)
        view.addSubview(googleLoginButton)
        view.addSubview(appleLoginButton)
        view.addSubview(emailLoginButton)
        view.addSubview(joinLabel)
        view.addSubview(joinButton)
        
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Device.widthScale(300))
            $0.height.equalTo(Device.heightScale(86))
            $0.top.equalToSuperview().offset(Device.heightScale(174))
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImage.snp.bottom).offset(Device.heightScale(61.6))
            $0.width.equalTo(Device.widthScale(287))
            $0.height.equalTo(Device.heightScale(48))
        }
        appleLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(googleLoginButton.snp.bottom).offset(Device.heightScale(20))
            $0.width.equalTo(Device.widthScale(287))
            $0.height.equalTo(Device.heightScale(48))
        }
        emailLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(Device.heightScale(20))
            $0.width.equalTo(Device.widthScale(287))
            $0.height.equalTo(Device.heightScale(48))
        }
        
        joinLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Device.widthScale(104))
            $0.top.equalTo(emailLoginButton.snp.bottom).offset(Device.heightScale(36))
        }
        joinButton.snp.makeConstraints {
            $0.leading.equalTo(joinLabel.snp.trailing).offset(6)
            $0.top.equalTo(emailLoginButton.snp.bottom).offset(Device.heightScale(36))
        }
    }
    @objc func loginAction() {
        let vc = TabBarController()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = vc
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        } else {
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
