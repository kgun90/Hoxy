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
    
    let meetingLocationView = WriteOptionItem(placeholder: "모임지역")
    let headCountView = WriteOptionItem(placeholder: "모임인원")
    let communicationLevelView = WriteOptionItem(placeholder: "소통레벨")
    let startTimeView = WriteOptionItem(placeholder: "시작시간")
    let meetingDurationView = WriteOptionItem(placeholder: "모임시간")
    
    let submitButton = BottomButton("작성하기")
    
    lazy var titleTextFieldView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var titleTextField = UITextField().then {
        $0.placeholder = "글 제목"
        $0.font = .BasicFont(.medium, size: 16)
    }
    
    lazy var contentTextView = UITextView().then {
        $0.font = .BasicFont(.medium, size: 18)
        $0.textColor = .black
        $0.textContainerInset = UIEdgeInsets(top: Device.heightScale(25), left: Device.widthScale(20), bottom: Device.heightScale(20), right: Device.widthScale(20))
    }
    
    lazy var contentCountLabel = UILabel().then {
        $0.font = .BasicFont(.light, size: 12)
        $0.textColor = .labelGray
    }

    lazy var tagView = UIView().then {
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

        $0.backgroundColor = .white
        $0.addSubview(tagScrollView)
        
        tagScrollView.snp.makeConstraints { sv in
            sv.top.equalToSuperview()
            sv.bottom.equalToSuperview()
            sv.leading.equalTo(iv.snp.trailing)
            sv.trailing.equalToSuperview()
        }
    }
    
    lazy var tagDescriptionLabel = UILabel().then {
        $0.text = "이곳을 눌러 태그를 추가하세요"
        $0.font = .BasicFont(.light, size: 12)
        $0.textColor = .init(hex: 0x818181)
    }
    
    
    lazy var tagScrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        
        $0.addSubview(tagStackView)
        
        tagStackView.snp.makeConstraints { sv in
            sv.height.equalTo(Device.heightScale(30))
            sv.leading.equalToSuperview().offset(Device.widthScale(10))
            sv.trailing.equalToSuperview().offset(Device.widthScale(-10))
            sv.centerY.equalToSuperview()
        }
    }
    
    lazy var tagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = Device.widthScale(10)
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
    
    private var dataManager = WriteDataManager()
    private var viewModel = WriteViewModel()
  
    var userDataManager = UserDataManager()
    var postDataManager = PostDataManager()
    
    var getTag = TagVC()
    
    var postData: PostDataModel?
    
    var menu = writeMenu.meetingTime
    var mode = writeMode.write

    let locs = LocationService()

    var postID: String?
    var writer = ""
    var nickName = ""
    
    var hashTag: [String] = []
   
    let pickerView = UIPickerView()
    
    let locationPicker = UIPickerView()
    let headCountPicker = UIPickerView()
    let communicationPicker = UIPickerView()
    let durationPicker = UIPickerView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        if let id = postID {
            mode = .update
            viewModel.postID = id          
            viewModel.getPostData(id)
        }
        viewModel.titleSet()
        configureUI()
        configureTextField()

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
    
    
    func hashTagSet() {
//        hashTag.insert(communicationLevelView.textField.text ?? "", at: 0)
        viewModel.writeContents.tag = hashTag
    }
   
    func nicknameSetting(_ nickname: String) {
        let description = "\(writer)님은 \n이번 모임에서 \(nickname)(으)로 활동합니다."
        nicknameLabel.attributedText = description.attributedText(withString: description, boldString: nickname, font: .BasicFont(.light, size: 13))
    }
        

    @objc func submitAction() {
        showIndicator()
        hashTagSet()

        let ok = UIAlertAction(title: "확인", style: .default) { (action) in
            self.viewModel.submitAction()
            if self.mode == .write {
                self.navigationController?.popViewController(animated: true)
            }

            self.moveToRoot(TabBarController())
        }
      presentAlert(title: "글 작성하기", message: "글이 게시됩니다. \n계속하시겠습니까?",isCancelActionIncluded: true, with: ok)
    }
}

extension WriteVC: TagDelegate {
    func getTagList(_ tagList: [String]) {
        hashTag = tagList
        tagDescriptionLabel.isHidden = tagList.count > 0
        tagStackView.subviews.forEach { $0.removeFromSuperview() }
        tagList.forEach {
            let tag = TagItem($0)
            tag.tagButton.title = $0
            tagStackView.addArrangedSubview(tag)
        }
        
    }
}
// MARK: Update Mode 일때 필요한 메서드
extension WriteVC {
    func updateSetting(_ data: PostDataModel) {
        if mode == .update {
            titleTextField.text = data.title
            meetingLocationView.textField.isEnabled = false
            meetingLocationView.textField.text = data.town
            headCountView.textField.text = String(data.headcount)
            communicationLevelView.textField.text = Constants.communicationDic[data.communication]
            updateStartTime(data.start)
            meetingDurationView.textField.text = Constants.meetingDurationDic[data.duration]
            contentTextView.text = data.content
        
            self.hashTag = data.tag.filter{ !Constants.communicationLevel.contains($0) }
            getTagList(hashTag)
            
            viewModel.writeContents.title = data.title
            viewModel.writeContents.location = data.location
    
            viewModel.writeContents.town = data.town
            viewModel.writeMenu.value.location = data.town
            
            viewModel.writeContents.headCount = data.headcount
            viewModel.writeMenu.value.headCount = String(data.headcount)
            
            viewModel.writeContents.communication = data.communication
            viewModel.writeMenu.value.communicationLevel = Constants.communicationLevel[data.communication]
            
            viewModel.writeContents.emoji = data.emoji
            viewModel.writeContents.start = data.start
            
            viewModel.writeContents.duration = data.duration
            viewModel.writeMenu.value.meetingDuration = Constants.meetingDurationDic[data.duration] ?? ""
            
            viewModel.writeContents.tag = hashTag//data.tag
            viewModel.writeContents.content = data.content
            viewModel.writeContents.view = data.view
            
         
        }
    }

    func updateStartTime(_ start: Date) {
        startTimeView.textField.font = .BasicFont(.regular, size: 13)
        let dateFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy년 MM월 dd일 HH시mm분"
        }
        let selectedDate = dateFormatter.string(from: start)
        viewModel.writeContents.start = start
        startTimeView.textField.text = selectedDate
    }
}

extension WriteVC: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        postModelModify()
        viewModel.submitButtonValidation()
    }
    
    func postModelModify() {
        viewModel.writeContents.title = titleTextField.text ?? ""
        viewModel.writeContents.content = contentTextView.text
    }
    
//    각 Textfield 영역 선택 후 PickerView 이외 영역 선택으로 Dismiss 동작을 할 때
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text != nil {
            switch textField {
            case meetingLocationView.textField:
                if meetingLocationView.textField.text?.isEmpty == true {
                    viewModel.pickerViewAction(mode: .location, row: 0)
                }
                return
            case headCountView.textField:
                if headCountView.textField.text?.isEmpty == true {
                    viewModel.pickerViewAction(mode: .headCount, row: 0)
                }
                
            case communicationLevelView.textField:
                if communicationLevelView.textField.text?.isEmpty == true {
                    viewModel.pickerViewAction(mode: .communicationLevel, row: 0)
                }
               
            case meetingDurationView.textField:
                if meetingDurationView.textField.text?.isEmpty == true {
                    viewModel.pickerViewAction(mode: .meetingDuration, row: 0)
                }
            default:
                return
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dismissAction()
        pickerView.selectRow(0, inComponent: 0, animated: true)
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
// MARK: PickerView Setting
extension WriteVC {
    func configureTextField() {
        headCountView.textField.delegate = self
        meetingLocationView.textField.delegate = self
        communicationLevelView.textField.delegate = self
        startTimeView.textField.delegate = self
        meetingDurationView.textField.delegate = self

        createPickerView()
        createDatePicker()
        dismissPickerView()
    }

    func createPickerView() {
       
        pickerView.delegate = self
        pickerView.dataSource = self
        
        locationPicker.delegate = self
        locationPicker.dataSource = self
        headCountPicker.delegate = self
        headCountPicker.dataSource = self
        communicationPicker.delegate = self
        communicationPicker.dataSource = self
        durationPicker.delegate = self
        durationPicker.dataSource = self
            
        
        meetingLocationView.textField.inputView = locationPicker
        headCountView.textField.inputView = headCountPicker
        communicationLevelView.textField.inputView = communicationPicker
        meetingDurationView.textField.inputView = durationPicker
    }
    
    func createDatePicker() {
        let locale = Locale(identifier: "ko")
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        
        components.calendar = calendar
        components.day = 7

        let datePicker = UIDatePicker().then {
            $0.datePickerMode = .dateAndTime
            $0.date = Date()
            $0.locale = locale
            
            $0.minimumDate = Date()
            $0.maximumDate = calendar.date(byAdding: components, to: Date())
            $0.minuteInterval = 30
         
            $0.addTarget(self, action: #selector(datePickerAction(sender:)), for: .valueChanged)
            if #available(iOS 13.4, *) {
                $0.preferredDatePickerStyle = .wheels
            }
        }
     
        startTimeView.textField.inputView = datePicker
    }
    
    @objc func datePickerAction(sender: UIDatePicker) {
        startTimeView.textField.font = .BasicFont(.regular, size: 13)
        let dateFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        }
        let selectedDate = dateFormatter.string(from: sender.date)
        viewModel.writeContents.start = sender.date
        Log.any(sender.date)
        startTimeView.textField.text = selectedDate
    }
    
    func dismissPickerView() {
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(dismissAction))
        let toolBar = UIToolbar().then {
            $0.sizeToFit()
            $0.setItems([button], animated: true)
            $0.isUserInteractionEnabled = true
        }
      
        meetingLocationView.textField.inputAccessoryView = toolBar
        headCountView.textField.inputAccessoryView = toolBar
        communicationLevelView.textField.inputAccessoryView = toolBar
        meetingDurationView.textField.inputAccessoryView = toolBar
        
        startTimeView.textField.inputAccessoryView = toolBar
    }
    
    @objc func dismissAction() {
        self.view.endEditing(true)
    }
}
// MARK: - PickerViewDelegate
extension WriteVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case locationPicker:
            return LocationService.getTownData().count
        case headCountPicker:
            return Constants.headCount.count
        case communicationPicker:
            return Constants.communicationLevel.count
        case durationPicker:
            return Constants.meetingDuration.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Log.any(component)
        switch pickerView {
        case locationPicker:
            return LocationService.getTownData()[row]
        case headCountPicker:
            return String(Constants.headCount[row])
        case communicationPicker:
            return Constants.communicationLevel[row]
        case durationPicker:
            return Constants.meetingDuration[row]
        default:
            return ""
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.pickerViewAction(mode: menu, row: row)
    }
    
    
}
// MARK: - TextViewDelegate
extension WriteVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textFieldDidChange()
        contentCountLabel.text = "\(textView.text.count) / 400"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        return numberOfChars < 401
    }
}

// MARK: - Configure UI
extension WriteVC {
    func configureUI() {
        binding()
        setting()
        layout()
    }
    
    func binding() {
        viewModel.navTitle.bind { [weak self] title in
            self?.navigationItem.title = title
        }
        viewModel.buttonTitle.bind { [weak self] title in
            self?.submitButton.titleSet(title)
        }
        
        viewModel.postData.bind { [weak self] data in
            self?.postData = data
            self?.updateSetting(data)
            self?.dismissIndicator()
        }
        
        viewModel.writeMenu.bind { [weak self] menu in
            self?.meetingLocationView.textField.text = menu.location
            self?.headCountView.textField.text = menu.headCount
            self?.communicationLevelView.textField.text = menu.communicationLevel
            self?.meetingDurationView.textField.text = menu.meetingDuration
        }
        
        viewModel.writer.bind { [weak self] data in
            self?.writer = data
        }
        
        viewModel.nickname.bind { [weak self] data in
            self?.nickName = data
            self?.nicknameSetting(data)
        }

        viewModel.submitButton.bind { [weak self] button in
            self?.submitButton.isEnabled = button.enable
            self?.submitButton.backgroundColor = button.color
        }
    }
    
    @objc func tagViewAction() {
        getTag.viewModel.tagData.value = self.hashTag
        self.present(getTag, animated: true, completion: nil)
    }
    
    func setting() {
        viewModel.requestUserData()
        
        contentTextView.delegate = self
        getTag.delegate = self
        
        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        meetingLocationView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
        headCountView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
        communicationLevelView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
        meetingDurationView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
        
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
    
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
            $0.height.equalTo(Device.isNotch ? Device.heightScale(280) : Device.heightScale(200))
        }
        
        contentCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(contentTextView.snp.bottom)
            $0.trailing.equalTo(contentTextView.snp.trailing).offset(Device.widthScale(-20))
        }
        
        submitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.isNotch ? Device.heightScale(108) : Device.heightScale(70))
        }
        
        layoutHashtag()
        layoutNicknameView()
        layoutWriteDescription()
  
    }
    
    func layoutHashtag(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tagViewAction))
        
        tagView.addGestureRecognizer(gesture)
        view.addSubview(tagView)
        tagView.addSubview(tagDescriptionLabel)
        
        tagDescriptionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        tagView.snp.makeConstraints {
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
            $0.top.equalTo(tagView.snp.bottom)
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
        tagView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        nicknameView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
    }
    
}
