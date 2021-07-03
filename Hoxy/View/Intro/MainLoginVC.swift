//
//  MainLoginVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit
import SnapKit
import Then
import CoreLocation

class MainLoginVC: UIViewController {
    // MARK: - Properties
    lazy var logoImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        return iv
    }()

    let googleLoginButton = LoginButton("구글로 로그인", titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    let appleLoginButton = LoginButton("애플로 로그인", titleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    let emailLoginButton = LoginButton("이메일로 로그인", titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9787401557, green: 0.8706828952, blue: 0.06605642289, alpha: 1))

    lazy var joinLabel = UILabel().then {
        $0.text = "처음 오셨나요 HOXY?"
        $0.font = .BasicFont(.semiBold, size: 15)
        $0.textColor = UIColor(hex: 0x7b6b6b)
    }
    
    lazy var joinButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor(hex: 0x004aad), for: .normal)
        $0.titleLabel?.font = .BasicFont(.semiBold, size: 15)
        $0.addTarget(self, action: #selector(joinAction), for: .touchUpInside)
    }
    private var viewModel = MainViewModel()
    var town: CLLocation?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loginCheck()
        buttonTarget()
        configureUI()
    }
    
    // MARK: - Selectors
    func buttonTarget() {
        googleLoginButton.addTarget(self, action: #selector(googleLoginAction), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleLoginAction), for: .touchUpInside)
        emailLoginButton.addTarget(self, action: #selector(emailLoginAction), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    @objc func googleLoginAction() {
        
    }
    
    @objc func appleLoginAction() {
 
    }
    
    @objc func emailLoginAction() {
        let vc = EmailLoginVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func joinAction() {
        let vc = JoinVC()
        vc.modalPresentationStyle = .overFullScreen
        
        present(vc, animated: true, completion: nil)
        
    }
     
    // MARK: - Helpers
    
    func configureUI() {
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
            $0.height.equalTo(19)
            $0.top.equalTo(emailLoginButton.snp.bottom).offset(Device.heightScale(36))
        }
    }  
}
