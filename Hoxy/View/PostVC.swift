//
//  PostVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/03.
//

import UIKit
import Firebase

class PostVC: BaseViewController, SingleDataDelegate {

    
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
        $0.font = .BasicFont(.medium, size: 14)
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
        $0.text = "􀋭 191"
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .labelGray
    }
    
    var gradeButton = GradeButton(mode: .tableCell, 1990)
    
    
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
    
    lazy var hashtagLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 12)
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
    
    lazy var listTableView = UITableView().then {
        $0.backgroundColor = .mainBackground
    }
    
    lazy var bottomView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var postID = PostDataModel().id
    var postDataManager = PostDataManager()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        postDataManager.singleDelegate = self
        postDataManager.requestSingleData(postID)
        layoutUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
        bottomView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
    }
    // MARK: - Selectors
    
    // MARK: - Helpers
    func layoutUI() {
        layoutTopView()
        layoutMiddleView()
        view.addSubview(mainScroll)
        view.addSubview(bottomView)
        
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
            $0.leading.equalToSuperview().offset(Device.widthScale(85))
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
        
        mainScroll.addSubview(hashtagView)
        hashtagView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(35))
        }
        
        mainScroll.addSubview(writerProfileView)
        writerProfileView.snp.makeConstraints {
            $0.top.equalTo(hashtagView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(60))
        }
        
        mainScroll.addSubview(relatedMeetingView)
        relatedMeetingView.snp.makeConstraints {
            $0.top.equalTo(writerProfileView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(50))
        }
    }
    
    func getSingleData(_ postData: PostDataModel) {
        navigationItem.title = postData.title
        commuicationLavelEmoji.text = postData.emoji
        meetingTimeLabel.text = getMeetingTime(postData.start, postData.duration)
        locationLabel.text = postData.town
        writeTimeLabel.text = postData.date.relativeTime_abbreviated
        viewsLabel.text = String(postData.view)
        
        var birthYear = 0
        postData.writer?.getDocument(completion: { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    birthYear = data["birth"] as! Int
                }
            }
        })
        
        gradeButton = GradeButton(mode: .tableCell, birthYear)
        attenderCountLabel.text = String(postData.headcount)
        
        contentLabel.text = postData.content

        dismissIndicator()
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
            return  "\(startTime)~\(endTime) \(hour)시간\(minute)분"
        } else {
            return ""
        }
        
       
    }
    func setting() {
//        listTableView.delegate = self
//        listTableView.dataSource = self
        listTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        listTableView.tableFooterView = UIView()
    }
}

//extension PostVC: UITableViewDataSource, UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//
//
//}
