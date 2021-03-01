//
//  UIViewController.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/29.
//

import UIKit
import SnapKit
import CoreLocation

extension UIViewController {
    // MARK: 빈 화면을 눌렀을 때 키보드가 내려가도록 처리
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    // MARK: 취소와 확인이 뜨는 UIAlertController
    func presentAlert(title: String, message: String? = nil,
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      handler: ((UIAlertAction) -> Void)? = nil) {
        self.dismissIndicator()
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let actionDone = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(actionDone)
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: 커스텀 UIAction이 뜨는 UIAlertController
    func presentAlert(title: String? = nil, message: String? = nil,
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      with actions: UIAlertAction ...) {
        self.dismissIndicator()
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: 커스텀 하단 경고창
    func presentBottomAlert(message: String, target: ConstraintRelatableTarget? = nil, offset: Double? = -12) {
        let alertSuperview = UIView()
        alertSuperview.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        alertSuperview.layer.cornerRadius = 10
        alertSuperview.isHidden = true
    
        let alertLabel = UILabel()
        alertLabel.font = .BasicFont(.regular, size: 15)
        alertLabel.textColor = .white
        
        self.view.addSubview(alertSuperview)
        alertSuperview.snp.makeConstraints { make in
            make.bottom.equalTo(target ?? self.view.safeAreaLayoutGuide).offset(-12)
            make.centerX.equalToSuperview()
        }
        
        alertSuperview.addSubview(alertLabel)
        alertLabel.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
        }
        
        alertLabel.text = message
        alertSuperview.alpha = 1.0
        alertSuperview.isHidden = false
        UIView.animate(
            withDuration: 2.0,
            delay: 1.0,
            options: .curveEaseIn,
            animations: { alertSuperview.alpha = 0 },
            completion: { _ in
                alertSuperview.removeFromSuperview()
            }
        )
    }
    
    // MARK: 인디케이터 표시
    func showIndicator() {
        IndicatorView.shared.show()
        IndicatorView.shared.showIndicator()
    }
    
    // MARK: 인디케이터 숨김
    @objc func dismissIndicator() {
        IndicatorView.shared.dismiss()
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
    
    func getMeetingTime(_ date: Date) -> String{
        let startTimeFormat = DateFormatter().then {
            $0.dateFormat = "MM/dd hh시mm분 예정"
        }
        let startTime = startTimeFormat.string(from: date)
        

        return startTime
    
    }
    var isModal: Bool {

           let presentingIsModal = presentingViewController != nil
           let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
           let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

           return presentingIsModal || presentingIsNavigation  || presentingIsTabBar
    }
}
