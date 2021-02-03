//
//  PostVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/03.
//

import UIKit

class PostVC: BaseViewController {
    // MARK: - Properties
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
    
    let gradeButton = GradeButton(mode: .tableCell, 1990)
    
    
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
    lazy var contentLabel = UILabel().then {
        $0.font = .BasicFont(.medium, size: 20)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.text = "컨텐츠 내용"
    }
  
    lazy var hashtagView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var writerProfileView = UIView().then {
        $0.backgroundColor = .white
    }
    lazy var similarMeetingView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var bottomView = UIView().then {
        $0.backgroundColor = .white
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Selectors
    햐
    // MARK: - Helpers
    func layoutUI() {
        layoutTopView()
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
        
        view.addSubview(topView)
        
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
    }
 
}
