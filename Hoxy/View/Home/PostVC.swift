//
//  PostVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/03.
//

import UIKit
import Firebase

enum buttonsStatus {
    case on
    case offOver
    case offWriter
    case offAlready
}

class PostVC: BaseViewController {
    // MARK: - Properties
    lazy var mainScroll = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }

    lazy var contentStackView = UIStackView().then {
        $0.backgroundColor = .green
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    lazy var modalTopView = UIView().then {
        $0.backgroundColor = .mainYellow
        $0.addSubview(dismissButton)
        $0.addSubview(modalTitleLabel)
        $0.addSubview(modalMoreButton)
        
        dismissButton.snp.makeConstraints {
            $0.centerY.equalTo(modalTitleLabel.snp.centerY)
            $0.leading.equalToSuperview().offset(Device.widthScale(20))
            $0.height.equalTo(Device.heightScale(30))
            $0.width.equalTo(Device.widthScale(30))
        }
        modalTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(Device.heightScale(-10))
        }
        modalMoreButton.snp.makeConstraints {
            $0.centerY.equalTo(modalTitleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(Device.widthScale(-20))
            $0.width.equalTo(Device.widthScale(30))
            $0.height.equalTo(Device.heightScale(30))
        }
    }
    lazy var modalTitleLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 18)
        $0.textColor = .black
        $0.text = "test Title"
    }
    lazy var dismissButton = UIButton().then {
        $0.setImage(UIImage(systemName: "multiply"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    lazy var modalMoreButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(barButtonAction), for: .touchUpInside)
    }
    
    lazy var topView = UIView().then {
        $0.backgroundColor = .white
        
        $0.addSubview(commuicationLavelEmoji)
        $0.addSubview(meetingTitleLabel)
        $0.addSubview(meetingTimeLabel)
        $0.addSubview(locationLabel)
        $0.addSubview(writeTimeLabel)
        $0.addSubview(viewsLabel)
        $0.addSubview(gradeButton)
        $0.addSubview(attenderCountView)
    }
    
    lazy var commuicationLavelEmoji = UILabel().then {
        $0.font = .BasicFont(.medium, size: 50)
    }
    
    lazy var meetingTitleLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 14)
        $0.textColor = .black
        $0.text = "예정시간"
    }
        
    lazy var meetingTimeLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .meetingTimeOrange
        $0.text = "만남 예정시간"
    }
    
    lazy var locationLabel = UILabel().then {
        $0.text = "동네"
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .labelGray
    }
    lazy var writeTimeLabel = UILabel().then {
        $0.text = "작성시간"
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .labelGray
    }
     lazy var viewsLabel = UILabel().then {
        $0.text = "191"
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .labelGray
    }
    
    lazy var gradeButton = GradeButton(mode: .tableCell)
    
    
    lazy var attenderCountView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: Device.widthScale(40), height: Device.heightScale(40))
        $0.layer.cornerRadius = $0.frame.size.height / 2
        $0.layer.borderColor = UIColor(hex: 0xeaeaea).cgColor
        $0.layer.borderWidth = 0.5
        $0.backgroundColor = .white
    }
    
    lazy var attenderCountLabel = UILabel().then {
        $0.text = "1/4"
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = UIColor(hex: 0x6c6c6c)
    }

    lazy var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    lazy var contentLabel = UITextView().then {
        $0.font = .BasicFont(.medium, size: 20)
        $0.textColor = .black
        $0.isEditable = false
    }
  
    lazy var hashtagView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var hashtagImage = UIImageView().then {
        $0.image = UIImage(systemName: "tag")
        $0.tintColor = UIColor(hex: 0x7b7b7b)
    }
    
    lazy var hashtagLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 15)
        $0.textColor = .hashtagBlue
    }
    
    lazy var writerProfileView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var writerNicknameLable = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 16)
        $0.textColor = .black
        $0.text = "nickname"
    }
    
    lazy var writerLocationLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .labelGray
        $0.text = "동네"
    }
    
    lazy var writerLevelTitleLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .labelGray
        $0.text = "인연지수"
    }
    
    lazy var writerAttendCountLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .labelGray
        $0.text = "모임 참여횟수"
    }
    
    lazy var relatedMeetingView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var relatedMeetingTitle = UILabel().then {
        $0.font = .BasicFont(.medium, size: 13)
        $0.textColor = .black
        $0.text = "연관모임"
    }
    
    lazy var relatedMeetingTag = UILabel().then {
        $0.font = .BasicFont(.light, size: 13)
        $0.textColor = UIColor(hex: 0x5a5a5a)
    }
    
    lazy var relatedMeetingTableView = UITableView().then {
        $0.backgroundColor = .mainBackground
    }
    
    lazy var bottomView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var bottomMeetingTimeLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 14)
        $0.textColor = UIColor(hex: 0x1a3bc4)
        $0.text = "예정시간"
    }
    
    lazy var bottomWriterInfoLabel = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 16)
        $0.textColor = UIColor(hex: 0x2f2f2f)
        $0.text = "00님의 모임"
    }
    
    lazy var bottomSubmitButton = UIButton().then {
        $0.titleLabel?.font = .BasicFont(.medium, size: 18)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .mainYellow
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
    
    private var postDataManager = PostDataManager()
    private var viewModel = PostViewModel()
    
    var postID: String = ""
    var relatedMeetingPost: [PostDataModel] = []
    var currentPost: PostDataModel?
    
    var commLevel = 0
    var submitState: buttonsStatus = .on
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        viewModel.getPostData(postID: postID)
        viewModel.getRelatedPostData()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
                
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBorder()
    }
       
    func configureData() {
        guard let post = currentPost else { return }
                
        writerProfile(post.chat, post.writer)
        viewModel.applyButtonCheck(post)
        addNaviButton()
        dismissIndicator()
    }
    
    // MARK: - Selectors
    @objc func backButtonAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func barButtonAction() {
        if currentPost?.writer?.documentID == Auth.auth().currentUser?.uid {
            let update = UIAlertAction(title: "수정", style: .default) { (action) in
                self.updateAction()
            }
            let delete = UIAlertAction(title: "삭제", style: .default) { (action) in
                self.deleteAction()
            }
            presentAlert(isCancelActionIncluded: true, preferredStyle: .actionSheet, with:update, delete)
        } else {
            let report = UIAlertAction(title: "모임 신고하기", style: .default) { (action) in
                self.reportAction()
            }
            let block = UIAlertAction(title: "주최자와 만나지 않기", style: .default) { (action) in
                self.blockAction()
            }
            presentAlert(isCancelActionIncluded: true, preferredStyle: .actionSheet, with:report, block)
        }
    }
    
    @objc func submitAction() {
        let nickname = "".nicknameGenerate()
        let ok = UIAlertAction(title: "네", style: .default) { (action) in
            PostDataManager.joinAction(post: self.currentPost!, nickname: nickname)
            self.navigationController?.popViewController(animated: true)
        }
        presentAlert(title: "모임 신청하기", message: "닉네임 \(nickname)(으)로 참가 하시겠습니까?", isCancelActionIncluded: true, with: ok)
        
    }
    
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    func addNaviButton() {
        let moreButton = UIBarButtonItem().then {
            $0.image = UIImage(systemName: "ellipsis")
            $0.target = self
            $0.action = #selector(barButtonAction)
        }
        
        navigationItem.rightBarButtonItem = moreButton
    }
    
    func getBottomTime(_ start: Date) -> String {
        let bottomTimeFormat = DateFormatter().then {
            $0.dateFormat = "MM월 dd일 hh시 mm분 예정"
        }
        let bottomTime = bottomTimeFormat.string(from: start)
        
        return bottomTime
    }
    
    func writerProfile(_ chat: DocumentReference?,_ writer: DocumentReference?) {
        guard let chat = chat else { return }
        guard let writer = writer else { return }
        
        UserDataManager.getUserData(byReference: writer) { data in
            self.writerLocationLabel.text = data.town
            self.writerAttendCountLabel.text = "총 모임참여 \(data.participation)회"
            self.gradeButton.getGrade(.tableCell,  data.birth)
        }
        
        ChatDataManager.getChattingData(byReference: chat) { data in
            guard let nickname = data.nickname[writer.documentID] else { return }
            self.writerNicknameLable.text = nickname as? String ?? ""
            self.bottomWriterInfoLabel.text = "\(nickname)의 모임"
        }
    }
    
    func readOtherPost(_ id: String) {
        let vc = PostVC()
        vc.postID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.relatedMeetingTableView.reloadData()
        }
    }
    
}

// MARK: Action Menu
extension PostVC {
//    Writer Menu
    func updateAction() {
        let vc = WriteVC()
        vc.postID = postID
        showIndicator()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteAction() {
        let ok = UIAlertAction(title: "예", style: .default) { (action) in
            print("delete")
            PostDataManager.deletaAction(post: self.currentPost!)
            self.moveToRoot(TabBarController())
        }
        presentAlert(title: "삭제하기", message: "현재 글을 삭제하시겠습니까?", isCancelActionIncluded: true, with: ok)
    }
//     User Menu
    func blockAction() {
        guard let fromID = Auth.auth().currentUser?.uid else { return }
        guard let toID = currentPost?.writer?.documentID else { return }
        guard let chatID = currentPost?.chat?.documentID else { return }
        
        ChatDataManager.bloackUser(fromID: fromID, toID: toID, chatID: chatID)
    }
    
    func reportAction() {
        var reportData = ReportModel(
            content: "",
            date: Date(),
            post: Constants.POST_COLLECTION.document(currentPost!.id),
            writer: currentPost?.writer)
        let alert = UIAlertController(title: "모임 신고하기", message: "해당 모임을 신고하는 사유를 입력바랍니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { (action) in
            reportData.content = (alert.textFields?[0].text)!
            self.reportCheck(reportData)
        }
        
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(actionCancel)
        alert.addTextField {
            $0.placeholder = "100자 이내입력"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func reportCheck(_ reportData: ReportModel) {
        let ok = UIAlertAction(title: "네", style: .default) { (action) in
            self.reportPost(reportData)
        }
        presentAlert(title: "모임 신고", message: "신고를 진행 하시겠습니까?", isCancelActionIncluded: true, with: ok)
    }
    
    func reportPost(_ reportData: ReportModel) {
        postDataManager.reportPost(reportData)
        presentOkOnlyAlert(title: "모임 신고하기", message: "신고가 완료 되었습니다.", handler: nil)
    }
}

extension PostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedMeetingPost.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.relatedMeetingTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath as IndexPath) as! HomeTableViewCell
        cell.postData = relatedMeetingPost[indexPath.row]       
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.heightScale(100)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        readOtherPost(relatedMeetingPost[indexPath.row].id)
    }


}
// MARK: Configure UI
extension PostVC {
    func configureUI() {
        binding()
        setting()
        layout()
    }
    
    func binding() {
        viewModel.applyButton.bind { [weak self] button in
            self?.bottomSubmitButton.backgroundColor = button.color
            self?.bottomSubmitButton.setTitle(button.title, for: .normal)
            self?.bottomSubmitButton.isEnabled = button.enable
        }

        viewModel.counterLabel.bind { [weak self] text in
            self?.attenderCountLabel.text = text
        }
        
        viewModel.post.bind { [weak self] data in
            self?.navigationItem.title = data.title
            self?.commLevel = data.communication
            
            self?.modalTitleLabel.text = data.title
            self?.commuicationLavelEmoji.text = data.emoji
            self?.meetingTimeLabel.text = self?.getMeetingTime(data.start, data.duration)
            self?.locationLabel.text = data.town
            self?.writeTimeLabel.text = data.date.relativeTime_abbreviated
            self?.viewsLabel.text = String(data.view)
            self?.contentLabel.text = data.content
            self?.hashtagLabel.text = "#" + data.tag.joined(separator: "#")
            self?.bottomMeetingTimeLabel.text = self?.getBottomTime(data.start)
            
            self?.currentPost = data
            self?.configureData()
        }
        
        viewModel.relatedPost.bind { [weak self] data in
            self?.relatedMeetingPost = data
            self?.reloadTable()
        }
    }
    
    func setting() {
        relatedMeetingTableView.delegate = self
        relatedMeetingTableView.dataSource = self
        relatedMeetingTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        relatedMeetingTableView.tableFooterView = UIView()
    }
    
    func layout() {
        view.addSubview(mainScroll)
        mainScroll.snp.makeConstraints {
            isModal ? $0.top.equalToSuperview().offset(Device.topHeight): $0.top.equalToSuperview()
            $0.leading.bottom.trailing.equalToSuperview()
    
        }
        
        mainScroll.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        if isModal {
            modalLayout()
        }
        layoutTopView()
        layoutMiddleView()
        layoutBottomView()
    }
    
    func modalLayout() {
        view.addSubview(modalTopView)
        
        modalTopView.snp.makeConstraints {
            $0.height.equalTo(Device.topHeight)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    func layoutTopView() {
        attenderCountView.addSubview(attenderCountLabel)
        contentStackView.addArrangedSubview(topView)
      
        topView.snp.makeConstraints {
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(Device.heightScale(80))
        }
        
        commuicationLavelEmoji.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(26))
        }
        
        meetingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(18))
            $0.leading.equalToSuperview().offset(Device.widthScale(90))
        }
        meetingTimeLabel.snp.makeConstraints {
            $0.top.equalTo(meetingTitleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(meetingTitleLabel.snp.leading)
        }
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(meetingTimeLabel.snp.bottom).offset(Device.heightScale(6))
            $0.leading.equalTo(meetingTitleLabel.snp.leading)
        }
        writeTimeLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.top)
            $0.leading.equalTo(locationLabel.snp.trailing).offset(Device.widthScale(3))
        }
        viewsLabel.snp.makeConstraints {
            $0.top.equalTo(writeTimeLabel.snp.top)
            $0.leading.equalTo(writeTimeLabel.snp.trailing).offset(4)
        }
        gradeButton.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.top)
            $0.leading.equalTo(viewsLabel.snp.trailing).offset(Device.widthScale(12))
            $0.width.equalTo(Device.widthScale(28))
            $0.height.equalTo(Device.heightScale(14))
        }
        attenderCountLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        attenderCountView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(Device.widthScale(-15))
            $0.width.equalTo(Device.widthScale(40))
            $0.height.equalTo(Device.heightScale(40))
        }
    }
    
    func layoutMiddleView() {
        contentView.addSubview(contentLabel)
        contentStackView.addArrangedSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(Device.heightScale(300))
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(20))
            $0.leading.equalToSuperview().offset(Device.widthScale(25))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-10))
            $0.bottom.equalToSuperview().offset(Device.heightScale(-10))
        }
        
        hashtagView.addSubview(hashtagImage)
        hashtagView.addSubview(hashtagLabel)
        contentStackView.addArrangedSubview(hashtagView)
        
        hashtagView.snp.makeConstraints {
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(Device.heightScale(35))
        }
        hashtagImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(19))
            $0.width.equalTo(Device.widthScale(22))
            $0.height.equalTo(Device.heightScale(22))
        }
        hashtagLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(48))
        }
        
        writerProfileView.addSubview(writerNicknameLable)
        writerProfileView.addSubview(writerLocationLabel)
        writerProfileView.addSubview(writerLevelTitleLabel)
        writerProfileView.addSubview(writerAttendCountLabel)
        contentStackView.addArrangedSubview(writerProfileView)
        
        writerProfileView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(60))
        }
        writerNicknameLable.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(10))
            $0.leading.equalToSuperview().offset(Device.widthScale(23))
        }
        writerLocationLabel.snp.makeConstraints {
            $0.bottom.equalTo(writerNicknameLable.snp.bottom)
            $0.leading.equalTo(writerNicknameLable.snp.trailing).offset(Device.widthScale(3))
        }
        writerLevelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(writerNicknameLable.snp.bottom).offset(Device.heightScale(5))
            $0.leading.equalTo(writerNicknameLable.snp.leading)
        }
        writerAttendCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(Device.widthScale(-21))
        }
        
        relatedMeetingView.addSubview(relatedMeetingTitle)
        contentStackView.addArrangedSubview(relatedMeetingView)
        
        relatedMeetingView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(50))
        }
        relatedMeetingTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(7))
            $0.leading.equalToSuperview().offset(Device.widthScale(20))
        }
        
        contentStackView.addArrangedSubview(relatedMeetingTableView)
        relatedMeetingTableView.snp.makeConstraints {
   
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Device.heightScale(300))

            
        }
    }
    
    func layoutBottomView() {
        bottomView.addSubview(bottomMeetingTimeLabel)
        bottomView.addSubview(bottomWriterInfoLabel)
        bottomView.addSubview(bottomSubmitButton)
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(108))
        }
        
        bottomSubmitButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(16))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-17))
            $0.width.equalTo(Device.widthScale(142))
            $0.height.equalTo(Device.heightScale(44))
        }
        
        bottomMeetingTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(21))
            $0.trailing.equalTo(bottomSubmitButton.snp.leading).offset(Device.widthScale(-7))
        }
        bottomWriterInfoLabel.snp.makeConstraints {
            $0.top.equalTo(bottomMeetingTimeLabel.snp.bottom).offset(Device.heightScale(-1))
            $0.trailing.equalTo(bottomMeetingTimeLabel.snp.trailing)
        }
    }
    
    func addBorder() {
        topView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        hashtagView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        writerProfileView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        bottomView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        relatedMeetingView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        bottomView.addBorder(toSide: .top, color: .mainBackground, borderWidth: 0.5)
    }
    
}
