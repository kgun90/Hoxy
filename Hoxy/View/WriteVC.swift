//
//  WriteVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import UIKit
import Firebase

enum writeMenu {
    case location
    case headCount
    case communicationLevel
    case meetingTime
    case meetingDuration
}


class WriteVC: BaseViewController {
    // MARK: - Properties
    lazy var titleTextFieldView = UIView().then {
        $0.backgroundColor = .white
    }
    lazy var titleTextField = UITextField().then {
        $0.placeholder = "글 제목"
        $0.font = .BasicFont(.medium, size: 16)
    }
    
    let meetingAreaView = WriteOptionItem(title: "모임지역")
    let peopleCountView = WriteOptionItem(title: "모임인원")
    let communicationLevelVeiw = WriteOptionItem(title: "소통레벨")
    let meetingTimeView = WriteOptionItem(title: "시작시간")
    let meetingDurationView = WriteOptionItem(title: "모임시간")
    
    lazy var contentTextView = UITextView().then {
        $0.font = .BasicFont(.medium, size: 18)
        $0.textColor = .black
        $0.textContainerInset = UIEdgeInsets(top: 25, left: 20, bottom: 20, right: 20)
        
    }
    
    lazy var contentCountLabel = UILabel().then {
        $0.font = .BasicFont(.light, size: 12)
        $0.textColor = .labelGray
    }
    
    lazy var hashTagView = UIView().then {
        $0.backgroundColor = .white
    }
    lazy var hashTagImage = UIImageView().then {
        $0.image = UIImage(systemName: "tag")
        $0.tintColor = UIColor(hex: 0x7b7b7b)
    }
    lazy var hashTagTextField = UITextField().then {
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .hashtagBlue
    }
    
    lazy var nicknameView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var nicknameLabel = UILabel().then {
        $0.font = .BasicFont(.light, size: 13)
        $0.textColor = UIColor(hex: 0x1c1a1a)
        $0.text = "닉네임 설명"
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    lazy var writeDescriptionView = UIView().then {
        $0.backgroundColor = .white
    }
    lazy var writeDescriptionLabel = UILabel().then {
        $0.font = .BasicFont(.light, size: 11)
        $0.textColor = UIColor(hex: 0x003bff)
        $0.text = "글 작성시 모임 대화방이 생성되며,\n 신청자는 대화방에 참여됩니다."
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let submitButton = BottomButton("작성하기")
    var menu = writeMenu.meetingTime
    var postModel = PostDataModel()
  
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameSetting()
        configureTextField()
        settingUI()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViewsBorder()
    }
    // MARK: - Selectors
    @objc func editCheckAction() {
        if titleTextField.text != nil,
           meetingAreaView.textField.text != nil,
           peopleCountView.textField.text != nil,
           communicationLevelVeiw.textField.text != nil,
           meetingDurationView.textField.text != nil,
           contentTextView.text.count > 10 {
            submitButton.isEnabled = true
            submitButton.backgroundColor = .mainYellow
        }
    }
    @objc func action() {
        self.view.endEditing(true)
    }
    
    @objc func submitAction() {
        
    }
    // MARK: - Helpers
    func layout() {
        view.addSubview(titleTextFieldView)
        titleTextFieldView.addSubview(titleTextField)
        view.addSubview(meetingAreaView)
        view.addSubview(peopleCountView)
        view.addSubview(communicationLevelVeiw)
        view.addSubview(meetingTimeView)
        view.addSubview(meetingDurationView)
        view.addSubview(contentTextView)
        view.addSubview(contentCountLabel)
        view.addSubview(submitButton)
        
        titleTextFieldView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.topHeight)
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(50))
        }
        titleTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Device.widthScale(20))
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview()
        }
        meetingAreaView.snp.makeConstraints {
            $0.top.equalTo(titleTextFieldView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalTo(view.frame.size.width / 2)
            $0.height.equalTo(Device.widthScale(50))
        }
        peopleCountView.snp.makeConstraints {
            $0.top.equalTo(titleTextFieldView.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(view.frame.size.width / 2)
            $0.height.equalTo(Device.widthScale(50))
        }
        communicationLevelVeiw.snp.makeConstraints {
            $0.top.equalTo(meetingAreaView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(50))
        }
        meetingTimeView.snp.makeConstraints {
            $0.top.equalTo(communicationLevelVeiw.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalTo(view.frame.size.width / 2)
            $0.height.equalTo(Device.heightScale(50))
        }
        meetingDurationView.snp.makeConstraints {
            $0.top.equalTo(communicationLevelVeiw.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(view.frame.size.width / 2)
            $0.height.equalTo(Device.heightScale(50))
        }
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(meetingTimeView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(280))
        }
        contentCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(contentTextView.snp.bottom)
            $0.trailing.equalTo(contentTextView.snp.trailing).offset(Device.widthScale(-20))
        }
        submitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(108))
        }
        layoutHashtag()
        layoutNicknameView()
        layoutWriteDescription()
  
    }
    
    func layoutHashtag(){
        hashTagView.addSubview(hashTagImage)
        hashTagView.addSubview(hashTagTextField)
        view.addSubview(hashTagView)
        
        hashTagView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(35))
        }
        hashTagImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(20))
            $0.width.equalTo(Device.widthScale(24))
            $0.height.equalTo(Device.heightScale(24))
        }
        hashTagTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(hashTagImage.snp.trailing).offset(Device.widthScale(7))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-10))
        }
    }
    
    func layoutNicknameView() {
        nicknameView.addSubview(nicknameLabel)
        view.addSubview(nicknameView)
        
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(hashTagView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(45))
        }
        nicknameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
       
    }
    
    func layoutWriteDescription() {
        writeDescriptionView.addSubview(writeDescriptionLabel)
        view.addSubview(writeDescriptionView)
        
        writeDescriptionView.snp.makeConstraints {
            $0.top.equalTo(nicknameView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalTo(submitButton.snp.top)
        }
        writeDescriptionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func layoutViewsBorder() {
        titleTextFieldView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        meetingAreaView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        meetingAreaView.addBorder(toSide: .right, color: .mainBackground, borderWidth: 0.5)
        peopleCountView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        communicationLevelVeiw.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        meetingTimeView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        meetingTimeView.addBorder(toSide: .right, color: .mainBackground, borderWidth: 0.5)
        meetingDurationView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        contentTextView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        hashTagView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        nicknameView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
    }
    
    func nicknameSetting() {
        let nickName = "\(set.title[Int.random(in: 0 ..< set.title.count)]) \(set.nickname[Int.random(in: 0 ..< set.nickname.count)])"
        let writer = "kgun90@gmail.com"
        let description = "\(writer)님은 \n이번 모임에서 \(nickName)(으)로 활동합니다."
        nicknameLabel.attributedText = description.attributedText(withString: description, boldString: "\(nickName)", font: .BasicFont(.light, size: 13))
        
        
    }
    override func configureNavigationBar() {
        navigationItem.title = "모임글 작성"
    }
    
    func configureTextField() {
        peopleCountView.textField.delegate = self
        meetingAreaView.textField.delegate = self
        communicationLevelVeiw.textField.delegate = self
        meetingTimeView.textField.delegate = self
        meetingDurationView.textField.delegate = self
        
        
        meetingAreaView.textField.attributedPlaceholder = NSAttributedString(string: "모임 장소 >", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        
        createPickerView()
        dismissPickerView()
    }

    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        
        let datePicker = UIDatePicker()
        
        meetingAreaView.textField.inputView = pickerView
        peopleCountView.textField.inputView = pickerView
        communicationLevelVeiw.textField.inputView = pickerView
   
        meetingDurationView.textField.inputView = pickerView

        meetingTimeView.textField.setDatePicker(target: self, selector: #selector(meetingTimeChange))
//        meetingTimeView.textField.addTarget(self, action: #selector(meetingTimeChange), for: .valueChanged)
    }
    
    @objc func meetingTimeChange() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .short
//        meetingTimeView.textField.text =
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        meetingAreaView.textField.inputAccessoryView = toolBar
        peopleCountView.textField.inputAccessoryView = toolBar
        communicationLevelVeiw.textField.inputAccessoryView = toolBar
//        meetingTimeView.textField.inputAccessoryView = toolBar
        meetingDurationView.textField.inputAccessoryView = toolBar
    }
    
    func settingUI() {
        submitButton.isEnabled = false
        contentTextView.delegate = self
        
        
        titleTextField.addTarget(self, action: #selector(editCheckAction), for: .editingChanged)
        meetingAreaView.textField.addTarget(self, action: #selector(editCheckAction), for: .editingChanged)
        peopleCountView.textField.addTarget(self, action: #selector(editCheckAction), for: .editingChanged)
        communicationLevelVeiw.textField.addTarget(self, action: #selector(editCheckAction), for: .editingChanged)
        meetingDurationView.textField.addTarget(self, action: #selector(editCheckAction), for: .editingChanged)
        
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        
    }
    
    func createPost() {
//        set.fs.collection(set.Table.post).addDocument(data: [
//         title:
//         content:  = ""
//         writer:
//         headcount:  = 0
//         tag: [String] = []
//         date:
//         emoji:  = ""
//         communication:  = 0
//         start:
//         duration:  = 0
//         city:  = ""
//         town:  = ""
//         location:
//            "view": 0,
//         "chat": DocumentReference
//        ])
    }
 
}

extension WriteVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case meetingAreaView.textField:
            menu = .location
        case peopleCountView.textField:
            menu = .headCount
        case communicationLevelVeiw.textField:
            menu = .communicationLevel
        case meetingTimeView.textField:
            menu = .meetingTime
        case meetingDurationView.textField:
            menu = .meetingDuration
        default:
            print("wrong")
        }
        return true
    }
}

extension WriteVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch menu {
        case .location:
            return set.meetingLocationDemo.count
        case .headCount:
            return set.headCount.count
        case .communicationLevel:
            return set.communicationLevel.count
        case .meetingDuration:
            return set.meetingDuration.count
        default:
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch menu {
        case .location:
            return set.meetingLocationDemo[row]
        case .headCount:
            return String(set.headCount[row])
        case .communicationLevel:
            return set.communicationLevel[row]
        case .meetingDuration:
            return set.meetingDuration[row]
        default:
            return String(set.headCount[row])
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch menu {
        case .location:
            meetingAreaView.textField.text = set.meetingLocationDemo[row]
//            postModel.location = set.meetingLocationDemo[row]
        case .headCount:
            peopleCountView.textField.text = String(set.headCount[row])
            postModel.headcount = set.headCount[row]
        case .communicationLevel:
            communicationLevelVeiw.textField.text = set.communicationLevel[row]
            postModel.communication = row
        case .meetingDuration:
            meetingDurationView.textField.text = set.meetingDuration[row]
        default:
            return
        }
       
    }
    
}

extension WriteVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        editCheckAction()
        contentCountLabel.text = "\(textView.text.count) / 400"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        return numberOfChars < 401
    }
}

