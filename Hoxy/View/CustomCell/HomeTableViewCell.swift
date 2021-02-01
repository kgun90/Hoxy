//
//  HomeTableViewCell.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/27.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    // MARK: - Properties
    lazy var emojiLable = UILabel().then {
        $0.text = "😇"
        $0.font = .BasicFont(.regular, size: 40)
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "글제목"
        $0.font = .BasicFont(.medium, size: 18)
        $0.textColor = .black
    }
    
    lazy var meetingTimeLabel = UILabel().then {
        $0.text = "만남시간"
        $0.font = .BasicFont(.medium, size: 11)
        $0.textColor = .meetingTimeOrange
    }
    
    let gradeButton = GradeButton(mode: .tableCell, 1990)
    
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
    
    lazy var hashTagLabel = UILabel().then {
        $0.text = "#해쉬태그"
        $0.font = .BasicFont(.medium, size: 11)
        $0.textColor = .hashtagBlue
    }
    
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

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Selectors

    // MARK: - Helpers
    func configureUI() {
        contentView.addSubview(emojiLable)
        contentView.addSubview(titleLabel)
        contentView.addSubview(meetingTimeLabel)
        contentView.addSubview(gradeButton)
        contentView.addSubview(locationLabel)
        contentView.addSubview(writeTimeLabel)
        contentView.addSubview(viewsLabel)
        contentView.addSubview(hashTagLabel)
        attenderCountView.addSubview(attenderCountLabel)
        contentView.addSubview(attenderCountView)
        
        
        emojiLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(23))
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(16))
            $0.leading.equalToSuperview().offset(Device.widthScale(84))
            $0.width.equalTo(Device.widthScale(220))
        }
        meetingTimeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Device.heightScale(2))
            $0.leading.equalTo(titleLabel.snp.leading)
            
        }
        
        gradeButton.snp.makeConstraints {
            $0.top.equalTo(meetingTimeLabel.snp.top)
            $0.leading.equalTo(meetingTimeLabel.snp.trailing).offset(Device.widthScale(12))
            $0.width.equalTo(Device.widthScale(28))
            $0.height.equalTo(Device.heightScale(14))
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(meetingTimeLabel.snp.bottom).offset(Device.heightScale(3))
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        writeTimeLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.top)
            $0.leading.equalTo(locationLabel.snp.trailing).offset(Device.widthScale(2))
        }
        
        viewsLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.top)
            $0.leading.equalTo(writeTimeLabel.snp.trailing).offset(Device.widthScale(9))
        }
        
        hashTagLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(locationLabel.snp.bottom).offset(Device.heightScale(4))
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
    
  
}
