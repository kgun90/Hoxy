//
//  WriteVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/01.
//

import UIKit
import Firebase

class WriteVC: BaseViewController {
    // MARK: - Properties
    lazy var textFieldView = UIView().then {
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
    var nickName = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
      
        nickName = set.title[Int.random(in: 0 ..< set.title.count)] + set.nickname[Int.random(in: 0 ..< set.nickname.count)]
        let writer = "kgun90@gmail.com"
        let description = "\(writer)님은 \n이번 모임에서 \(nickName)(으)로 활동합니다."
        nicknameLabel.attributedText = description.attributedText(withString: description, boldString: "\(self.nickName)", font: .BasicFont(.light, size: 13))
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViewsBorder()
    }
    // MARK: - Selectors
    
    // MARK: - Helpers
    func layout() {
        view.addSubview(textFieldView)
        textFieldView.addSubview(titleTextField)
        view.addSubview(meetingAreaView)
        view.addSubview(peopleCountView)
        view.addSubview(communicationLevelVeiw)
        view.addSubview(meetingTimeView)
        view.addSubview(meetingDurationView)
        view.addSubview(contentTextView)
        view.addSubview(submitButton)
        
        textFieldView.snp.makeConstraints {
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
            $0.top.equalTo(textFieldView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalTo(view.frame.size.width / 2)
            $0.height.equalTo(Device.widthScale(50))
        }
        peopleCountView.snp.makeConstraints {
            $0.top.equalTo(textFieldView.snp.bottom)
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
        textFieldView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
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
    
    
    override func configureNavigationBar() {
        navigationItem.title = "모임글 작성"
    }

}

extension WriteVC: UITextFieldDelegate {
    
}

extension WriteVC: UITextViewDelegate {
    
}
