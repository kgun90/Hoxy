//
//  EmailLoginVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/30.
//

import UIKit
import Firebase

class EmailLoginVC: UIViewController {
    // MARK: - Properties
    let topView = TopView("이메일로 로그인")

    lazy var logoImage = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }

    let emailItem = JoinInputItem("이메일", "양식에 맞게 입력 바랍니다.", false)
    let passItem = JoinInputItem("비밀번호", "영문/숫자/기호를 모두 포함한 8~16자리 입력", true)
   
    let loginButton = BottomButton("로그인", #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1))
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loginCheck()
        buttonTarget()
        layout()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailItem.tf.addUnderLine()
        passItem.tf.addUnderLine()
    }
    
    // MARK: - Selectors

    @objc func textFieldDidChange() {
        // textField 입력 실시간 감지
        loginCheck()
    }

    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loginAction() {
        showIndicator()
        if let email = emailItem.tf.text, let pass = passItem.tf.text {
            Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
                if let e = error {
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    let alert = UIAlertController(title: "로그인 실패", message: "이메일과 패스워드를 확인해주세요.", preferredStyle: .alert)
                    alert.addAction(ok)
                    self?.present(alert, animated: true, completion: nil)
                    print(e.localizedDescription)
                    self!.dismissIndicator()
                } else {
                    let vc = LocationVC()
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = vc
                        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                    } else {
                        vc.modalPresentationStyle = .overFullScreen
                        self?.present(vc, animated: true, completion: nil)
                    }
                    self?.dismissIndicator()
                }
            }
        }
        
    }
    func loginCheck() {
        if Auth.auth().currentUser?.uid != nil {
            showIndicator()
            let vc = LocationVC()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = vc
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                dismissIndicator()
            } else {
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helpers
    func layout() {
        view.addSubview(topView)
        view.addSubview(logoImage)
        view.addSubview(emailItem)
        view.addSubview(passItem)
        view.addSubview(loginButton)
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(88))
        }
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom).offset(Device.heightScale(30))
            $0.width.equalTo(Device.widthScale(300))
            $0.height.equalTo(Device.heightScale(86.4))
        }
        emailItem.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImage.snp.bottom).offset(Device.heightScale(40))
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(60))
            
        }
        passItem.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emailItem.snp.bottom).offset(Device.heightScale(20))
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(60))
        }

        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(85))
        }
    }
    
    
    // MARK: - Logic
    func buttonTarget() {
        
        emailItem.tf.delegate = self
        passItem.tf.delegate = self
       
        loginButton.isEnabled = false
        emailItem.tf.keyboardType = .emailAddress
          
        topView.back.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
       
        passItem.tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailItem.tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
       
    }
    
    func enableLogin() {
        if self.emailItem.tf.text?.validateEmail() ?? false,
           self.passItem.tf.text?.validatePassword() ?? false{
            loginButton.isEnabled = true
            loginButton.backgroundColor = .mainYellow
        }
    }
    
  
    
}

extension EmailLoginVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // 키보드 영역 이외 터치시 키보드 해제
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            switch textField {
            case emailItem.tf:
                if emailItem.tf.text?.validateEmail() ?? false {
                    emailItem.descriptionLabel.text = "올바른 양식 입니다."
                    emailItem.descriptionLabel.textColor = .green
                } else {
                    emailItem.descriptionLabel.text = "올바른 양식으로 입력 바랍니다."
                    emailItem.descriptionLabel.textColor = .red
                }
            case passItem.tf:
                if passItem.tf.text?.validatePassword() ?? false {
                    passItem.descriptionLabel.text = "올바른 양식 입니다."
                    passItem.descriptionLabel.textColor = .green
                } else {
                    passItem.descriptionLabel.text = "올바른 양식으로 입력 바랍니다."
                    passItem.descriptionLabel.textColor = .red
                }
            default:
                print("?")
            }
            return true
        } else {
            
            return true
        }

    }
}
