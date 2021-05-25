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
    private var viewModel = EmailLoginViewModel()

    lazy var logoImage = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }
    
    let topView = TopView("이메일로 로그인")
    let emailItem = JoinInputItem("이메일", "id1234@hoxy.com", false)
    let passItem = JoinInputItem("비밀번호", "영문 대소문자/숫자/기호를 모두 포함한 8~16자리 입력", true)
    let loginButton = BottomButton("로그인", .labelGray)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loginCheck()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailItem.tf.addUnderLine()
        passItem.tf.addUnderLine()
    }
    
    // MARK: - Selectors
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loginAction() {
        self.showIndicator()
        if let email = emailItem.tf.text, let pass = passItem.tf.text {
            Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
                if let e = error {
                    self?.dismissIndicator()
                    print(e.localizedDescription)
                    let ok = UIAlertAction(title: "확인", style: .default) { action in
                        self?.viewModel.passwordInitialize()
                        self?.viewModel.password = ""
                        self?.viewModel.buttonEnableCheck()
                        
                        return
                    }
                    self?.presentAlert(title: "로그인 실패", message: "이메일과 패스워드를 확인해주세요.", isCancelActionIncluded: false, preferredStyle: .alert, with: ok)
                } else {
                    self?.dismissIndicator()
                    self?.moveToRoot(LocationVC())
                }
            }
        }
    }
}

extension EmailLoginVC: UITextFieldDelegate {
    @objc func textFieldDidChange(sender: UITextField) {
        if sender == emailItem.tf {
            viewModel.email = sender.text
            viewModel.descriptionEmailText()
        } else {
            viewModel.password = sender.text
            viewModel.descriptionPassText()
        }
        viewModel.buttonEnableCheck()
    }
    // 키보드 영역 이외 터치시 키보드 해제
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UI Configure
extension EmailLoginVC {
    func configureUI() {
        binding()
        setting()
        layout()
    }
    
    func binding() {
        viewModel.emailText.bind { [weak self] email in
            self?.emailItem.tf.text = email
        }
        viewModel.passText.bind { [weak self] password in
            self?.passItem.tf.text = password
        }
        
        viewModel.emailDes.bind { [weak self] label in
            self?.emailItem.descriptionLabel.text = label.text
            self?.emailItem.descriptionLabel.textColor = label.color
        }
        
        viewModel.passDes.bind { [weak self] label in
            self?.passItem.descriptionLabel.text = label.text
            self?.passItem.descriptionLabel.textColor = label.color
        }
        
        viewModel.buttonSet.bind { [weak self] button in
            self?.loginButton.isEnabled = button.visability
            self?.loginButton.backgroundColor = button.color
        }
    }
    
    func setting() {
        emailItem.tf.delegate = self
        passItem.tf.delegate = self
       
        loginButton.isEnabled = false
        emailItem.tf.keyboardType = .emailAddress
          
        topView.back.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
       
        passItem.tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailItem.tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
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
}
