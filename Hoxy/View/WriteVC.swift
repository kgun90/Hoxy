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

enum writeMode {
    case write
    case update
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
    
    let meetingLocationView = WriteOptionItem(placeholder: "모임지역")
    let headCountView = WriteOptionItem(placeholder: "모임인원")
    let communicationLevelView = WriteOptionItem(placeholder: "소통레벨")
    let startTimeView = WriteOptionItem(placeholder: "시작시간")
    let meetingDurationView = WriteOptionItem(placeholder: "모임시간")
    
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
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: "tag")
        iv.tintColor = UIColor(hex: 0x7b7b7b)
        
        $0.addSubview(iv)
        
        iv.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(20))
            $0.width.equalTo(Device.widthScale(24))
            $0.height.equalTo(Device.heightScale(24))
        }
        
        $0.addSubview(hashTagTextField)
        
        hashTagTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(47))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-10))
        }
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
    var mode = writeMode.write
    var postModel = PostDataModel()
    var userDataManager = UserDataManager()
    var postDataManager = PostDataManager()
    let locs = LocationService()

    var uid: String?
    var writer = ""
    var nickName = ""
    
    var hashTag: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        userDataManager.delegate = self
        userDataManager.requestUserData()
        
        postDataManager.singleDelegate = self
        if let id = uid {
            postDataManager.requestSingleData(id)
            mode = .update
        }
   
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
   
        if titleTextField.text!.count > 5,
           meetingLocationView.textField.text != nil,
           headCountView.textField.text != nil,
           communicationLevelView.textField.text != nil,
           meetingDurationView.textField.text != nil,
           contentTextView.text.count > 10 {
            submitButton.isEnabled = true
            submitButton.backgroundColor = .mainYellow
        } else {
            submitButton.isEnabled = false
            submitButton.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1)
        }
        
        hashTag.insert(communicationLevelView.textField.text ?? "", at: 0)
        hashTagSet()
        postModelModify()
    }
    
    @objc func action() {
        self.view.endEditing(true)
    }
    
    @objc func datePickerAction(sender: UIDatePicker) {
        startTimeView.textField.font = .BasicFont(.regular, size: 13)
        let dateFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy년 MM월 dd일 HH시mm분"
        }
        let selectedDate = dateFormatter.string(from: sender.date)
        postModel.start = sender.date
        startTimeView.textField.text = selectedDate
    }
    
    @objc func submitAction() {
        showIndicator()
     
        let ok = UIAlertAction(title: "확인", style: .default) { (action) in
            if self.mode == .write {
                self.createPost()
            } else {
                self.updatePost()
            }
            self.moveToRoot(TabBarController())
        }
        
        presentAlert(title: "글 작성하기", message: "글이 게시됩니다. \n계속하시겠습니까?",isCancelActionIncluded: true, with: ok)
    }
    
    // MARK: - Helpers
    func layout() {
        view.addSubview(titleTextFieldView)
        titleTextFieldView.addSubview(titleTextField)
        view.addSubview(meetingLocationView)
        view.addSubview(headCountView)
        view.addSubview(communicationLevelView)
        view.addSubview(startTimeView)
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
        meetingLocationView.snp.makeConstraints {
            $0.top.equalTo(titleTextFieldView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalTo(view.frame.size.width / 2)
            $0.height.equalTo(Device.widthScale(50))
        }
        headCountView.snp.makeConstraints {
            $0.top.equalTo(titleTextFieldView.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(view.frame.size.width / 2)
            $0.height.equalTo(Device.widthScale(50))
        }
        communicationLevelView.snp.makeConstraints {
            $0.top.equalTo(meetingLocationView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(50))
        }
        startTimeView.snp.makeConstraints {
            $0.top.equalTo(communicationLevelView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalTo(view.frame.size.width / 2)
            $0.height.equalTo(Device.heightScale(50))
        }
        meetingDurationView.snp.makeConstraints {
            $0.top.equalTo(communicationLevelView.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(view.frame.size.width / 2)
            $0.height.equalTo(Device.heightScale(50))
        }
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(meetingDurationView.snp.bottom)
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
        view.addSubview(hashTagView)
        hashTagView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(35))
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
        meetingLocationView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        meetingLocationView.addBorder(toSide: .right, color: .mainBackground, borderWidth: 0.5)
        headCountView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        communicationLevelView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        startTimeView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        startTimeView.addBorder(toSide: .right, color: .mainBackground, borderWidth: 0.5)
        meetingDurationView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        contentTextView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        hashTagView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        nicknameView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
    }
    
    func nicknameSetting(_ nickname: String) {
        let description = "\(writer)님은 \n이번 모임에서 \(nickname)(으)로 활동합니다."
        nicknameLabel.attributedText = description.attributedText(withString: description, boldString: "\(nickname)", font: .BasicFont(.light, size: 13))
    }
    
    override func configureNavigationBar() {
        if ((uid?.isEmpty) != nil) {
            navigationItem.title = "작성글 수정"
            submitButton.titleSet("수정하기")
        } else {
            navigationItem.title = "모임글 작성"
        }
      
    }
    
    func configureTextField() {
        headCountView.textField.delegate = self
        meetingLocationView.textField.delegate = self
        communicationLevelView.textField.delegate = self
        startTimeView.textField.delegate = self
        meetingDurationView.textField.delegate = self

        
        createPickerView()
        dismissPickerView()
    }

    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let locale = Locale(identifier: "ko")

        let datePicker = UIDatePicker().then {
            $0.datePickerMode = .dateAndTime
            $0.date = Date()
            $0.locale = locale
            $0.minimumDate = Date()
           
            $0.minuteInterval = 30
            if #available(iOS 13.4, *) {
                $0.preferredDatePickerStyle = .wheels
            }
        }
       
        meetingLocationView.textField.inputView = pickerView
        headCountView.textField.inputView = pickerView
        communicationLevelView.textField.inputView = pickerView
        meetingDurationView.textField.inputView = pickerView
        
        datePicker.addTarget(self, action: #selector(datePickerAction(sender:)), for: .valueChanged)
        startTimeView.textField.inputView = datePicker
       
        
        pickerView.selectRow(0, inComponent: 0, animated: true)

    }
    
    func dismissPickerView() {
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(action))
        let toolBar = UIToolbar().then {
            $0.sizeToFit()
            $0.setItems([button], animated: true)
            $0.isUserInteractionEnabled = true
        }
      
        meetingLocationView.textField.inputAccessoryView = toolBar
        headCountView.textField.inputAccessoryView = toolBar
        communicationLevelView.textField.inputAccessoryView = toolBar
        startTimeView.textField.inputAccessoryView = toolBar
        meetingDurationView.textField.inputAccessoryView = toolBar
    }
    
    func settingUI() {
        if mode == .update {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
       
        contentTextView.delegate = self
        
        
        titleTextField.addTarget(self, action: #selector(editCheckAction), for: .editingChanged)
        meetingLocationView.textField.addTarget(self, action: #selector(editCheckAction), for: .editingChanged)
        headCountView.textField.addTarget(self, action: #selector(editCheckAction), for: .editingChanged)
        communicationLevelView.textField.addTarget(self, action: #selector(editCheckAction), for: .editingChanged)
        meetingDurationView.textField.addTarget(self, action: #selector(editCheckAction), for: .editingChanged)
        hashTagTextField.addTarget(self, action: #selector(editCheckAction), for: .editingChanged)
        
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
    
    func postModelModify() {
        postModel.title = titleTextField.text!
        postModel.content = contentTextView.text
        postModel.date = Date()
        
        postModel.town = meetingLocationView.textField.text!
        
    }
    
    func createPost() {
        let post = set.fs.collection(set.Table.post).addDocument(data: [
            "title": postModel.title,
            "content": postModel.content,
            "writer": postModel.writer! as DocumentReference,
            "headcount": postModel.headcount,
            "location": postModel.location! as GeoPoint,
            "tag": postModel.tag,
            "date": postModel.date,
            "emoji":  postModel.emoji,
            "communication":  postModel.communication,
            "start": postModel.start,
            "duration":  postModel.duration,
            "town":  postModel.town,
            "view": postModel.view
        ])
        
        let chat = set.fs.collection(set.Table.chatting).addDocument(data: [
            "member": [Auth.auth().currentUser?.uid],
            "nickname": [ Auth.auth().currentUser?.uid : nickName],
            "post" : post
        ])
        
        post.updateData([
            "chat" : chat
        ])
        dismissIndicator()
    }
    
    func updatePost() {
        set.fs.collection(set.Table.post).document(uid!).updateData([
            "title": postModel.title,
            "content": postModel.content,
            "headcount": postModel.headcount,
            "location": postModel.location! as GeoPoint,
//            "tag": postModel.tag,
            "date": postModel.date,
            "emoji":  postModel.emoji,
            "communication":  postModel.communication,
            "start": postModel.start,
            "duration":  postModel.duration,
            "town":  postModel.town
        ])
    }
    
    func hashTagSet() {
        if !hashTagTextField.text!.isEmpty {
            let original = hashTagTextField.text!
            let removeHash = original.replacingOccurrences(of: "#", with: "", options: NSString.CompareOptions.literal, range: nil).components(separatedBy: " ")
            hashTag = removeHash
        }
        hashTag.insert(communicationLevelView.textField.text ?? "", at: 0)
        postModel.tag = hashTag
    }
    
    func updateSetting(_ data: PostDataModel) {
        if mode == .update {
            titleTextField.text = data.title
            postModel.title = data.title
            
            meetingLocationView.textField.isEnabled = false
            meetingLocationView.textField.text = data.town
            postModel.location = data.location
            postModel.town = data.town
            
            headCountView.textField.text = String(data.headcount)
            postModel.headcount = data.headcount
            
            communicationLevelView.textField.text = data.tag[0]
            postModel.communication = data.communication
            postModel.emoji = data.emoji
            
            updateStartTime(data.start)
            
            meetingDurationView.textField.text = "\(data.duration / 60)시간 \(data.duration % 60)분"
            postModel.duration = data.duration
            
            contentTextView.text = data.content
            postModel.content = data.content
            
            postModel.chat = data.chat
            postModel.view = data.view
            postModel.tag = data.tag
              
        }
    }

    func updateStartTime(_ start: Date) {
        
        startTimeView.textField.font = .BasicFont(.regular, size: 13)
        let dateFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy년 MM월 dd일 HH시mm분"
        }
        let selectedDate = dateFormatter.string(from: start)
        postModel.start = start
        startTimeView.textField.text = selectedDate
    }
}

extension WriteVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text != nil {
            switch textField {
            case meetingLocationView.textField:
                if meetingLocationView.textField.text == locs.towns[0] || meetingLocationView.textField.text?.isEmpty == true {
                    meetingLocationView.textField.text = locs.towns[0]
                    postModel.location = GeoPoint(latitude: LocationService.currentLocation!.coordinate.latitude, longitude: LocationService.currentLocation!.coordinate.longitude)
                }
                
            case headCountView.textField:
                if headCountView.textField.text?.isEmpty == true {
                    headCountView.textField.text = String(set.headCount[0])
                }
            case communicationLevelView.textField:
                if communicationLevelView.textField.text?.isEmpty == true {
                    communicationLevelView.textField.text = set.communicationLevel[0]
                    let emojiRand = Int.random(in: 0...2)
                    postModel.emoji = set.communicationEmoji[0][emojiRand]
                }
               
            case meetingDurationView.textField:
                if meetingDurationView.textField.text?.isEmpty == true {
                    meetingDurationView.textField.text = set.meetingDuration[0]
                    postModel.duration = 30
                }
            default:
                return
            }
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        editCheckAction()
        switch textField {
        case meetingLocationView.textField:
            menu = .location
        case headCountView.textField:
            menu = .headCount
        case communicationLevelView.textField:
            menu = .communicationLevel
        case meetingDurationView.textField:
            menu = .meetingDuration
        default:
            return true
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
            return locs.towns.count
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
            return locs.towns[row]
        case .headCount:
            return String(set.headCount[row])
        case .communicationLevel:
            return set.communicationLevel[row]
        case .meetingDuration:
            return set.meetingDuration[row]
        default:
            return ""
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch menu {
        case .location:
            meetingLocationView.textField.text = locs.towns[row]
            postModel.location = GeoPoint(latitude: locs.locations[row].coordinate.latitude, longitude: locs.locations[row].coordinate.longitude)
           
        case .headCount:
            headCountView.textField.text = String(set.headCount[row])
            postModel.headcount = set.headCount[row]
            
        case .communicationLevel:
            communicationLevelView.textField.text = set.communicationLevel[row]
            let emojiRand = Int.random(in: 0...2)
            postModel.emoji = set.communicationEmoji[row][emojiRand]
            print(postModel.emoji)
            postModel.communication = row
            if postModel.tag[0] != set.communicationLevel[row] {
                postModel.tag.insert(set.communicationLevel[row], at: 0)
//                postModel.tag.append(set.communicationLevel[row])
            }
          
        case .meetingDuration:
            meetingDurationView.textField.text = set.meetingDuration[row]
            postModel.duration = (row+1)*30
            
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


extension WriteVC: UserDataManagerDelegate {
    func getUserData(_ userData: MemberModel) {
        writer = userData.email
        postModel.writer = set.fs.collection(set.Table.member).document(userData.uid)
     
        if mode == .write {
//            let name = "\(set.title[Int.random(in: 0 ..< set.title.count)]) \(set.nickname[Int.random(in: 0 ..< set.nickname.count)])"
            let name:String = "".nicknameGenerate()
            nickName = name
            nicknameSetting(name)
        }
        dismissIndicator()
    }
}

extension WriteVC: SingleDataDelegate {
    func getSingleData(_ postData: PostDataModel) {
        updateSetting(postData)
        postData.chat?.getDocument(completion: { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    let member = data["nickname"] as! [String : String]
                    let nickname = member[self.postModel.writer!.documentID]!
                    self.nicknameSetting(nickname)
                }
            }
        })
     
    }
}
