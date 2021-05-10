//
//  MyPageVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit
import Firebase
import CoreLocation

class MyPageVC: BaseViewController {

    // MARK: - Properties
    lazy var topView = UIView().then {
        $0.backgroundColor = .white

        $0.addSubview(user)
        $0.addSubview(progressView)
        $0.addSubview(emoji)
        $0.addSubview(emojiChangeButton)
        $0.addSubview(grade)
        $0.addSubview(levelLabel)

        user.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(12))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-14))
        }
        progressView.snp.makeConstraints {
            $0.top.equalTo(user.snp.bottom).offset(Device.heightScale(4))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-14))
            $0.width.equalTo(Device.widthScale(265))
            $0.height.equalTo(Device.heightScale(16))
        }
        
        emoji.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(12))
            $0.width.equalTo(Device.widthScale(78))
            $0.height.equalTo(Device.heightScale(78))
        }
        
        emojiChangeButton.snp.makeConstraints {
            $0.top.equalTo(emoji.snp.bottom).offset(Device.heightScale(-7.5))
            $0.centerX.equalTo(emoji.snp.centerX)
            $0.width.equalTo(Device.widthScale(28))
            $0.height.equalTo(Device.heightScale(15))
        }

        levelLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(Device.heightScale(-12))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-10))
        }

        grade.snp.makeConstraints {
            $0.centerY.equalTo(levelLabel.snp.centerY)
            $0.trailing.equalTo(levelLabel.snp.leading).offset(Device.widthScale(-5))
            $0.width.equalTo(Device.widthScale(28))
            $0.height.equalTo(Device.heightScale(14))
        }

    }
    
    lazy var user = UILabel().then { user in
        user.font = .BasicFont(.medium, size: 18)
        user.textColor = .labelGray
//        user.text = "kgun90@gmail.com 님의 \n 인연지수는"
        user.numberOfLines = 0
        user.textAlignment = .right
    }
    
    lazy var progressView = UIProgressView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 265, height: 16)
        $0.progressTintColor = #colorLiteral(red: 0.3019607843, green: 0.9568627451, blue: 0.3764705882, alpha: 1)
        $0.trackTintColor = .labelGray
        $0.progress = 0.7
        $0.layer.cornerRadius = 8//pv.bounds.size.height / 2
        $0.clipsToBounds = true
    }

    let grade = GradeButton(mode: .tableCell, 1990)
    
    lazy var emoji = UILabel().then {
        $0.font = .BasicFont(.regular, size: 60)
        $0.text = "😘"
        $0.textAlignment = .center
        $0.isEnabled = false
    }

    lazy var emojiChangeButton = UIButton().then {
        $0.setTitle("변경", for: .normal)
        $0.titleLabel?.font = .BasicFont(.regular, size: 12)
        $0.tintColor = .white
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(emojiChangeAction), for: .touchUpInside)
    }
    
    lazy var levelLabel = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 18)
        $0.textColor = .labelGray
        $0.text = "동네대장 🥳 입니다."
    }
    
    lazy var currentLocationView = UIView().then {
        $0.backgroundColor = .white
        
        $0.addSubview(currentLocationImage)
        $0.addSubview(currentLocationLabel)
        
        currentLocationImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(27))
            $0.width.equalTo(Device.widthScale(24))
            $0.height.equalTo(Device.heightScale(24))
        }
        
        currentLocationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(currentLocationImage.snp.trailing).offset(Device.widthScale(11))
        }
    }
    
    private let currentLocationImage = UIImageView().then {
        $0.image = UIImage(systemName: "mappin.and.ellipse")
        $0.tintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    }
    
    lazy var currentLocationLabel = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 14)
        $0.textColor = .meetingTimeOrange
        $0.text = "현재 동네"
    }
    
    lazy var logoutButton = UIButton().then {
        $0.setTitle("logout", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)

    }
    
    
    lazy var userLocationView = UIView().then {
        $0.backgroundColor = .white
        
        $0.addSubview(userLocationImage)
        $0.addSubview(userLocationLabel)
        
        userLocationImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(27))
            $0.width.equalTo(Device.widthScale(24))
            $0.height.equalTo(Device.heightScale(24))
        }
        
        userLocationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(userLocationImage.snp.trailing).offset(Device.widthScale(11))
        }
    }
    
    private let userLocationImage = UIImageView().then {
        $0.image = UIImage(systemName: "house")
        $0.tintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    }
    
    lazy var userLocationLabel = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 14)
        $0.textColor = .black
        $0.text = "우리 동네"
    }
    
    lazy var blockUserView = UIView().then {
        $0.backgroundColor = .white
        
        $0.addSubview(blockUserImage)
        $0.addSubview(blockUserLabel)
        
        blockUserImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(27))
            $0.width.equalTo(Device.widthScale(24))
            $0.height.equalTo(Device.heightScale(24))
        }
        
        blockUserLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(blockUserImage.snp.trailing).offset(Device.widthScale(11))
        }
    }
    
    private let blockUserImage = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.badge.xmark")
        $0.tintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    }
    
    private let blockUserLabel = UILabel().then {
        $0.font = .BasicFont(.semiBold, size: 14)
        $0.textColor = .black
        $0.text = "만남거부목록"
    }
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var currentTown = ""
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "마이페이지"
        layout()
        getUserData()
        gesture()
        getCurrentLocation()
    }


    // MARK: - Selectors
    @objc func emojiChangeAction() {
        let emoji: String = "".randomEmoji()
        let ok = UIAlertAction(title: "변경하기", style: .default) { (action) in
            self.emoji.text = emoji
            if let id = Auth.auth().currentUser?.uid {
                set.fs.collection(set.Table.member).document(id).updateData(["emoji" : emoji])
            }
        }
        let again = UIAlertAction(title: "다시하기", style: .default) { [self] (action) in
            emojiChangeAction()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        presentAlert(title: "프로필 이모티콘 바꾸기", message: emoji, with: ok, again, cancel)
    }
    
    @objc func logoutAction() {
        self.showIndicator()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let vc = MainLoginVC()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = vc
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        } else {
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }
        self.dismissIndicator()
    }
    
    // MARK: - Helpers
    func layout() {
        view.addSubview(topView)
        view.addSubview(currentLocationView)
        view.addSubview(userLocationView)
        view.addSubview(blockUserView)
        view.addSubview(logoutButton)
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.topHeight)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(120))
        }
        currentLocationView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(50))
        }
        userLocationView.snp.makeConstraints {
            $0.top.equalTo(currentLocationView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(50))
        }
        blockUserView.snp.makeConstraints {
            $0.top.equalTo(userLocationView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(50))
        }
        logoutButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func getUserData() {
        if let id = Auth.auth().currentUser?.uid {
            set.fs.collection(set.Table.member).document(id).addSnapshotListener { (snapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let data = snapshot?.data() {
                        let email = data["email"] as! String
                        let exp = data["exp"] as! Float
                        let town = data["town"] as! String
                        
                        self.user.text = "\(email) 님의 \n 인연지수는"
                        self.emoji.text = data["emoji"] as? String
                        self.progressView.progress = exp / 1000
                        self.userLocationLabel.text = "우리 동네 \(town)"
                    }
                }
                
            }
        }
    }
        
    func gesture() {
        let curLocTapGesture = UITapGestureRecognizer(target: self, action: #selector(currentLocationTapAction))
        curLocTapGesture.numberOfTouchesRequired = 1
        
        let userLocTapGesture = UITapGestureRecognizer(target: self, action: #selector(userLocationTapAction))
        userLocTapGesture.numberOfTouchesRequired = 1
        
        currentLocationView.addGestureRecognizer(curLocTapGesture)
        userLocationView.addGestureRecognizer(userLocTapGesture)
    }
        
    @objc func currentLocationTapAction() {
        let ok = UIAlertAction(title: "예", style: .default) { (action) in
            self.getCurrentLocation()
        }
        
        presentAlert(title: "현재 위치 설정하기", message: "현재 위치를 설정할까요?", isCancelActionIncluded: true, with: ok)
    }
    
    @objc func userLocationTapAction() {
        let ok = UIAlertAction(title: "예", style: .default) { (action) in
            self.updateUserLocation()
        }
        
        presentAlert(title: "우리동네 변경", message: "현재 위치를 우리동네로 변경하시겠습니까?", isCancelActionIncluded: true, with: ok)
    }

    func getCurrentLocation() {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestLocation()
        }
    }
    
    func getLocationName() {
        let geocode = CLGeocoder()
        geocode.reverseGeocodeLocation(currentLocation) { (placemark, error) in
            guard
                let mark = placemark,
                let town = mark.first?.subLocality
            else {
                return
            }
            self.currentTown = town
            self.currentLocationLabel.text = "현재 동네 \(town)"
        }
    }
    
    func updateUserLocation() {
        let location = GeoPoint(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let town = currentTown
        if let id = Auth.auth().currentUser?.uid {
            set.fs.collection(set.Table.member).document(id).updateData([
                "location" : location,
                "town": town
            ])
        }
    }
   

}
extension MyPageVC: CLLocationManagerDelegate {
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let location = locations.last {
           locationManager.stopUpdatingLocation()
           currentLocation = location
           
           getLocationName()
       }
   }
   
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print(error.localizedDescription)
   }
}
