//
//  JoinVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/24.
//

import UIKit
import Firebase

class JoinVC: UIViewController {
    // MARK: - Properties
    let topView = TopView("회원가입")
    
    private var viewModel = JoinViewModel()
    
    lazy var logoImage = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }

    let emailItem = JoinInputItem("이메일", "id1234@hoxy.com", false, "로그인, 비밀번호 찾기 등에 사용됩니다.")
    let passItem = JoinInputItem("비밀번호", "대소문자/숫자/기호를 모두 포함한 8~16자리 입력", true, "특수문자는 (! @ # $ % ^ & ? _ ~) 만 가능합니다." )
    let passCheckItem = JoinInputItem("비밀번호 확인", "입력하신 비밀번호를 다시 한번 입력 해주세요.", true)
    let progressButton = BottomButton("진행하기", .labelGray)
    
    lazy var phoneNumLabel = UILabel().then {
        $0.text = "휴대전화 번호"
        $0.font = .BasicFont(.medium, size: 14)
        $0.textColor = .black
    }
    
    lazy var phoneNumTextfield = UITextField().then {
        $0.placeholder = "- 기호를 제외한 번호를 입력해 주세요."
        $0.font = .BasicFont(.medium, size: 14)
        $0.keyboardType = .decimalPad

    }
    
    lazy var phoneNumButton = UIButton().then {
        $0.setTitle("인증하기", for: .normal)
        $0.titleLabel?.font = .BasicFont(.regular, size: 12)
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(authAction), for: .touchUpInside)
        $0.layer.cornerRadius = 5
    }
    
    lazy var authTextfield = UITextField().then {
        $0.placeholder = "인증번호 입력"
        $0.font = .BasicFont(.medium, size: 14)
        $0.keyboardType = .numberPad
       
    }
    
    lazy var authButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .BasicFont(.regular, size: 12)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
    }
    
    lazy var authCompleteLabel = UILabel().then {
        $0.text = "인증되었습니다."
        $0.font = .BasicFont(.medium, size: 10)
        $0.textColor = UIColor(hex: 0x918dff)
    }
    
    var authKeyboardStatus: Bool = false
    var veriID: String = ""
    var uid: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        optionSetting()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailItem.tf.addUnderLine()
        passItem.tf.addUnderLine()
        passCheckItem.tf.addUnderLine()
        phoneNumTextfield.addUnderLine()
        authTextfield.addUnderLine()
    }
    
    // MARK: - Selectors

    @objc func textFieldDidChange(sender: UITextField) {
        // textField 입력 실시간 감지
        switch sender {
        case emailItem.tf:
            viewModel.email = sender.text
        case passItem.tf:
            viewModel.password = sender.text
        case passCheckItem.tf:
            viewModel.passCheck = sender.text
            viewModel.descriptionPassCheckText()
        case phoneNumTextfield:
            if sender.text!.validatePhoneNum() {
                phoneNumButton.backgroundColor = .mainYellow
                phoneNumButton.isEnabled = true
            } else {
                phoneNumButton.backgroundColor = .labelGray
                phoneNumButton.isEnabled = false
            }
        case authTextfield:
            if sender.text!.validateAuthCode() {
                authButton.backgroundColor = .mainYellow
                authButton.isEnabled = true
            } else {
                authButton.backgroundColor = .labelGray
                authButton.isEnabled = false
            }
        default:
            return
        }
        authComplete()
    }
    
    @objc func authAction() {
        authHidden()
        phoneNumberAuthentication()
    }
        
    @objc func authCheckAction() {
        self.showIndicator()
        authSubmit(self.veriID, authTextfield.text ?? "")
    }
  
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func moveToSetting() {
        let vc = PersonalSettingVC()
        vc.modalPresentationStyle = .overFullScreen
           
        let joinData = JoinModel(email: emailItem.tf.text!, pass: passItem.tf.text!, phone: phoneNumTextfield.text!, uid: uid)
        
        vc.joinInfo = joinData
        
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    func binding() {
        viewModel.emailText.bind { [weak self] email in
            self?.emailItem.tf.text = email
        }
        viewModel.passText.bind { [weak self] password in
            self?.passItem.tf.text = password
        }
        viewModel.passCheckText.bind { [weak self] password in
            self?.passCheckItem.tf.text = password
        }
        
        viewModel.emailDesText.bind { [weak self] text in
            self?.emailItem.descriptionLabel.text = text
        }
        viewModel.passDesText.bind { [weak self] text in
            self?.passItem.descriptionLabel.text = text
        }
        viewModel.passCheckDesText.bind { [weak self] text in
            self?.passCheckItem.descriptionLabel.text = text
        }
        
        viewModel.emailDesColor.bind { [weak self] color in
            self?.emailItem.descriptionLabel.textColor = color
        }
        viewModel.passDesColor.bind { [weak self] color in
            self?.passItem.descriptionLabel.textColor = color
        }
        viewModel.passCheckDesColor.bind { [weak self] color in
            self?.passCheckItem.descriptionLabel.textColor = color
        }
        
        viewModel.buttonEnable.bind { [weak self] button in
            self?.progressButton.isEnabled = button
        }
        viewModel.buttonColor.bind { [weak self] color in
            self?.progressButton.backgroundColor = color
        }
    }
    
    func layout() {
        view.addSubview(topView)
        view.addSubview(logoImage)
        view.addSubview(emailItem)
        view.addSubview(passItem)
        view.addSubview(passCheckItem)
        view.addSubview(progressButton)
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(88))
        }
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom).offset(Device.heightScale(18))
            $0.width.equalTo(Device.widthScale(200))
            $0.height.equalTo(Device.heightScale(57.6))
        }
        emailItem.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImage.snp.bottom).offset(Device.heightScale(30))
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(60))
            
        }
        passItem.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emailItem.snp.bottom).offset(Device.heightScale(20))
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(60))
        }
        passCheckItem.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(passItem.snp.bottom).offset(Device.heightScale(20))
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(60))
        }
        progressButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(85))
        }
        phoneAuthLayout()
    }
    
    func phoneAuthLayout() {
        view.addSubview(phoneNumLabel)
        view.addSubview(phoneNumTextfield)
        view.addSubview(phoneNumButton)
        view.addSubview(authTextfield)
        view.addSubview(authButton)
        view.addSubview(authCompleteLabel)
        
        phoneNumLabel.snp.makeConstraints {
            $0.top.equalTo(passCheckItem.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(Device.widthScale(25))
        }
        phoneNumTextfield.snp.makeConstraints {
            $0.top.equalTo(phoneNumLabel.snp.bottom).offset(Device.heightScale(9))
            $0.leading.equalToSuperview().offset(Device.widthScale(32))
            $0.width.equalTo(Device.widthScale(250))
            $0.height.equalTo(Device.heightScale(30))
        }
        phoneNumButton.snp.makeConstraints {
            $0.top.equalTo(phoneNumLabel.snp.bottom).offset(Device.heightScale(9))
            $0.leading.equalTo(phoneNumTextfield.snp.trailing).offset(5)
            $0.width.equalTo(Device.widthScale(65))
            $0.height.equalTo(Device.heightScale(30))
        }
        authTextfield.snp.makeConstraints {
            $0.top.equalTo(phoneNumTextfield.snp.bottom).offset(Device.heightScale(12))
            $0.leading.equalToSuperview().offset(Device.widthScale(32))
            $0.width.equalTo(Device.widthScale(250))
            $0.height.equalTo(Device.heightScale(30))
        }
        authButton.snp.makeConstraints {
            $0.top.equalTo(phoneNumTextfield.snp.bottom).offset(Device.heightScale(12))
            $0.leading.equalTo(authTextfield.snp.trailing).offset(5)
            $0.width.equalTo(Device.widthScale(65))
            $0.height.equalTo(Device.heightScale(30))
        }
        authCompleteLabel.snp.makeConstraints {
            $0.top.equalTo(authTextfield.snp.bottom).offset(3)
            $0.leading.equalTo(authTextfield.snp.leading)
        }
    }
    // MARK: - Logic
    func optionSetting() {
        
        emailItem.tf.delegate = self
        passItem.tf.delegate = self
        passCheckItem.tf.delegate = self
        phoneNumTextfield.delegate = self
        authTextfield.delegate = self
        
        phoneNumButton.isEnabled = false
        authButton.isEnabled = false
        progressButton.isEnabled = false
        
        authButton.isHidden = true
        authTextfield.isHidden = true
        authCompleteLabel.isHidden = true
        
        emailItem.tf.keyboardType = .emailAddress
        
        phoneNumButton.backgroundColor = .labelGray
        authButton.backgroundColor = .labelGray
        
        topView.back.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        progressButton.addTarget(self, action: #selector(moveToSetting), for: .touchUpInside)
        phoneNumButton.addTarget(self, action: #selector(authAction), for: .touchUpInside)
        authButton.addTarget(self, action: #selector(authCheckAction), for: .touchUpInside)
        
        phoneNumTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        authTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passItem.tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailItem.tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        authTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func authComplete() {
        if self.emailItem.tf.text?.validateEmail() ?? false,
           self.passItem.tf.text?.validatePassword() ?? false,
           self.passItem.tf.text == self.passCheckItem.tf.text,
           self.phoneNumTextfield.text?.validatePhoneNum() ?? false,
           self.veriID != ""{
            progressButton.isEnabled = true
            progressButton.backgroundColor = .mainYellow
        }
    }
    
    func phoneNumberAuthentication() {
        let phoneNumber = "+82 \(String(Array(phoneNumTextfield.text ?? "")[1...]))"
    
        Auth.auth().languageCode = "kr"

        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (veriID, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            self.veriID = veriID ?? ""
            
        }
    }
    
    func authSubmit(_ veriID: String, _ veriCode: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: veriID, verificationCode: veriCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            print(authResult.debugDescription)
            self.dismissIndicator()
            self.authCompleteLabel.isHidden = false
            self.uid = authResult?.user.uid ?? ""
            self.dismissKeyboard()
           
        }
    }
  
    func authHidden() {
        authButton.isHidden = false
        authTextfield.isHidden = false
    }
    
}

extension JoinVC: UITextFieldDelegate {
    // 키보드 영역 이외 터치시 키보드 해제
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case authTextfield:
            authKeyboardStatus = true
        default:
            authKeyboardStatus = false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            switch textField {
            case emailItem.tf:
                viewModel.descriptionEmailText()
            case passItem.tf:
                viewModel.descriptionPassText()
            default:
                print("?")
            }
            return true
        } else {
            return true
        }

    }
}


extension JoinVC {
    // textField 중 authTextfield에 포커스 이동시 키보드 등장과 함께 화면이 위로 올라가는 동작을 하는 부분, 다른 textField로 포커스 이동시엔 해제한다.
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(note: NSNotification) {
        if authKeyboardStatus {
            self.view.frame.origin.y = -150
        } else {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
