//
//  PostVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/03.
//

import UIKit
import Firebase

class PostVC: BaseViewController, SingleDataDelegate, PostDataDelegate {


    
    // MARK: - Properties
    lazy var mainScroll = UIScrollView().then {
        $0.frame = CGRect(x: 0, y: 0, width: Device.screenWidth, height: Device.screenHeight)
        $0.contentSize = CGSize(width: Device.screenWidth, height: Device.screenHeight*2)
    }
    lazy var topView = UIView().then {
        $0.backgroundColor = .white
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
//        $0.imag
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
    
    lazy var listTableView = UITableView().then {
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
        $0.setTitle("신청하기", for: .normal)
        $0.titleLabel?.font = .BasicFont(.medium, size: 18)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .mainYellow
        $0.layer.cornerRadius = 8
    }
    
    var postID = PostDataModel().id
    var postDataManager = PostDataManager()
    var posts: [PostDataModel] = []
    var currentPost = PostDataModel()
    var commLevel = 0
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        postDataManager.singleDelegate = self
        postDataManager.delegate = self
        postDataManager.requestSingleData(postID)
        
        setting()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        hashtagView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        writerProfileView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        bottomView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        relatedMeetingView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        bottomView.addBorder(toSide: .top, color: .mainBackground, borderWidth: 0.5)
    }
    // MARK: - Selectors
    
    // MARK: - Helpers
    override func configureUI() {
        super.configureUI()
        
        let backButton = UIBarButtonItem().then {
            $0.image = UIImage(systemName: "arrow.left")
            $0.title = ""
            $0.style = .plain
            $0.target = self
            $0.action = #selector(backButtonAction)
        }
        navigationItem.backBarButtonItem = backButton
        
    }
    
    @objc func barButtonAction() {
        let update = UIAlertAction(title: "수정", style: .default) { (action) in
            self.updateAction()
        }
        let delete = UIAlertAction(title: "삭제", style: .default) { (action) in
            self.deleteAction()
        }
        
        presentAlert(isCancelActionIncluded: true, preferredStyle: .actionSheet, with:update, delete)
        
    }
    func updateAction() {
    
        let vc = WriteVC()
        vc.uid = postID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func deleteAction() {
        let ok = UIAlertAction(title: "예", style: .default) { (action) in
            print("delete")
            
            self.currentPost.chat?.delete()
            set.fs.collection(set.Table.post).document(self.currentPost.id).delete()
            let vc = TabBarController()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = vc
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            } else {
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        presentAlert(title: "삭제하기", message: "현재 글을 삭제하시겠습니까?", isCancelActionIncluded: true, with: ok)
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
 
    func layoutUI() {
        layoutTopView()
        layoutMiddleView()
        view.addSubview(mainScroll)
        layoutBottomView()
    }
    
    func layoutTopView() {
        topView.addSubview(commuicationLavelEmoji)
        topView.addSubview(meetingTitleLabel)
        topView.addSubview(meetingTimeLabel)
        topView.addSubview(locationLabel)
        topView.addSubview(writeTimeLabel)
        topView.addSubview(viewsLabel)
        topView.addSubview(gradeButton)
        
        attenderCountView.addSubview(attenderCountLabel)
        topView.addSubview(attenderCountView)
        mainScroll.addSubview(topView)
    
        topView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
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
        mainScroll.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
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
        mainScroll.addSubview(hashtagView)
        
        hashtagView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
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
        mainScroll.addSubview(writerProfileView)
        writerProfileView.snp.makeConstraints {
            $0.top.equalTo(hashtagView.snp.bottom)
            $0.centerX.equalToSuperview()
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
        mainScroll.addSubview(relatedMeetingView)
        relatedMeetingView.snp.makeConstraints {
            $0.top.equalTo(writerProfileView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(50))
        }
        relatedMeetingTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(7))
            $0.leading.equalToSuperview().offset(Device.widthScale(20))
        }
        
        mainScroll.addSubview(listTableView)
        listTableView.snp.makeConstraints {
            $0.top.equalTo(relatedMeetingView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
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
    
    func getSingleData(_ postData: PostDataModel) {
 
        currentPost = postData
        navigationItem.title = postData.title
        commLevel = postData.communication
        print(postData.communication)
        commuicationLavelEmoji.text = postData.emoji
        meetingTimeLabel.text = getMeetingTime(postData.start, postData.duration)
        locationLabel.text = postData.town
        writeTimeLabel.text = postData.date.relativeTime_abbreviated
        viewsLabel.text = String(postData.view)
        
      
        attenderCountLabel.text = String(postData.headcount)
        contentLabel.text = postData.content
        
        writerProfile(postData.chat!, postData.writer!)
        hashtagLabel.text = postData.tag[0]
        
        bottomMeetingTimeLabel.text = getBottomTime(postData.start)
 
        postDataManager.requestPostData()
        addNaviButton()
        dismissIndicator()
    }
    
    func addNaviButton() {
        let moreButton = UIBarButtonItem().then {
            $0.image = UIImage(systemName: "ellipsis")
            $0.target = self
            $0.action = #selector(barButtonAction)
        }
   
        if currentPost.writer?.documentID == Auth.auth().currentUser?.uid {
            navigationItem.rightBarButtonItem = moreButton
        }
    }
    
    func getPostData(_ postData: [PostDataModel]) {
        for post in postData {
            if postID != post.id && commLevel == post.communication {
                posts.append(post)
            }
        }
        listTableView.reloadData()
    }
    
    func getMeetingTime(_ start: Date, _ duration: Int) -> String{
        let startTimeFormat = DateFormatter().then {
            $0.dateFormat = "MM.dd hh시 mm분"
        }
        let startTime = startTimeFormat.string(from: start)
        
        let endTimeFormat = DateFormatter().then {
            $0.dateFormat = "hh시 mm분"
        }
        let end = start.addingTimeInterval(TimeInterval(duration * 60))
        let endTime = endTimeFormat.string(from: end)
        let timedifference = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)
        
        if let hour = timedifference.hour, let minute = timedifference.minute {
            return  "\(startTime)~\(endTime) \(hour)시간 \(minute)분"
        } else {
            return ""
        }
        
    }
    
    func getBottomTime(_ start: Date) -> String {
        let bottomTimeFormat = DateFormatter().then {
            $0.dateFormat = "MM월 dd일 hh시 mm분 예정"
        }
        let bottomTime = bottomTimeFormat.string(from: start)
        
        return bottomTime
    }
    
    func writerProfile(_ chat: DocumentReference,_ writer: DocumentReference) {
        writer.getDocument { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    let location = data["town"] as! String
                    self.writerLocationLabel.text = location
                    let count = data["participation"] as! Int
                    self.writerAttendCountLabel.text = "총 모임참여 \(count)회"
                    self.gradeButton.getGrade(.tableCell,  data["birth"] as! Int)
                }
              
            }
        }
        chat.getDocument { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let doc = snapshot?.data() {
                    let member = doc["member"] as! [String : String]
                    let nickname = member[writer.documentID] ?? ""
                    self.writerNicknameLable.text = nickname
                    self.bottomWriterInfoLabel.text = "\(nickname)의 모임"
                }
              
            }
        }
    }
    
    func setting() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        listTableView.tableFooterView = UIView()
    }
    
    func readPost(_ id: String) {
        let vc = PostVC()
        vc.postID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
}

extension PostVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.listTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath as IndexPath) as! HomeTableViewCell
        cell.emojiLable.text = posts[indexPath.row].emoji
        cell.titleLabel.text = posts[indexPath.row].title
        cell.locationLabel.text = posts[indexPath.row].town
        cell.writeTimeLabel.text = posts[indexPath.row].date.relativeTime_abbreviated
        cell.viewsLabel.text = String(posts[indexPath.row].view)
//        cell.meetingTimeLabel.text = posts[indexPath.section].start
        cell.attenderCountLabel.text = String(posts[indexPath.row].headcount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.heightScale(100)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        readPost(posts[indexPath.row].id)
    }


}
