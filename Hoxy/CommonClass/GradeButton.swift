//
//  GradeButton.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/25.
//

import UIKit
enum ScreenMode {
    case tableCell
    case personalSetting
}

class GradeButton: UIView {
    
    let gradeLabel = UILabel()

    init(mode: ScreenMode ,_ bornIn: Int = 1990) {
        super.init(frame: .zero)
      
        getGrade(mode, bornIn)
        addSubview(gradeLabel)
        gradeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getGrade(_ mode: ScreenMode, _ bornIn: Int) {

         let date = Date()
         let year = Calendar.current.component(.year, from: date)
         var fontSize = CGFloat()
         switch mode {
         case .personalSetting:
             fontSize = 14
         case .tableCell:
             fontSize = 8
         }
         let grade = (year - bornIn) / 10
         gradeLabel.text = "\(grade)학년"
         gradeLabel.font = .BasicFont(.medium, size: fontSize)
         gradeLabel.textColor = .white
         
         layer.cornerRadius = Device.heightScale(8)
         frame = CGRect(x: 0, y: 0, width: 47, height: 20)
         
         switch grade {
         case 2:
             backgroundColor = .blue
         case 3:
             backgroundColor = UIColor(hex: 0x55cc91)
         case 4:
             backgroundColor = .mainYellow
         case 5:
             backgroundColor = .purple
         default:
             backgroundColor = .black
         }
    }
}
