//
//  PersonalSettingVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/25.
//

import UIKit
import CoreLocation
import Firebase

class PersonalSettingVC: UIViewController {
    
    // MARK: - Properties
    private var joinDataManager = JoinDataManager()
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var years: [String] = []
    var joinInfo = JoinModel()
    var currentLatLon: GeoPoint?
    
    let topView = TopView("정보설정")
    let submitButton = BottomButton("가입하기")
    lazy var logoImage = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }
    
    lazy var locationTitleLabel = UILabel().then {
        $0.text = "위치 설정"
        $0.font = .BasicFont(.medium, size: 18)
        $0.textColor = .black
    }
    
    lazy var locationNameLabel = UILabel().then {
        $0.text = "동네이름"
        $0.font = .BasicFont(.medium, size: 18)
        $0.textColor = UIColor(hex: 0xc3c3c3)
    }
    
    lazy var locationSetButton = UIButton().then {
        $0.setTitle("설정하기", for: .normal)
        $0.titleLabel?.font = .BasicFont(.regular, size: 14)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .mainYellow
        $0.addTarget(self, action: #selector(locationSetting), for: .touchUpInside)
    }
    
    lazy var locationDescriptionLabel = UILabel().then {
        $0.text = "현재 위치 기반으로 설정 됩니다."
        $0.font = .BasicFont(.medium, size: 10)
        $0.textColor = UIColor(hex: 0x918dff)
    }
       
    lazy var ageLabel = UILabel().then {
        $0.text = "사용연령 설정"
        $0.font = .BasicFont(.medium, size: 18)
        $0.textColor = .black
    }
    
    lazy var ageTextField = UITextField().then {
        $0.placeholder = "출생년도 선택"
        $0.textAlignment = .center
        $0.font = .BasicFont(.medium, size: 18)
        $0.tintColor = .clear
    }
    
    lazy var resultStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .fillProportionally
    }
    
    lazy var resultEmailLabel = UILabel().then {
        $0.text = "kgun38@gmail.com 님은"
        $0.font = .BasicFont(.medium, size: 18)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    lazy var gradeViewCover = UIView().then {
        $0.backgroundColor = .white
    }
    
    var gradeView = GradeButton(mode: .personalSetting, 1990)
    
    lazy var resultBottomLabel = UILabel().then {
        $0.text = "입니다."
        $0.font = .BasicFont(.medium, size: 18)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    lazy var resultDescriptionLabel = UILabel().then {
        $0.text = "HOXY 서비스는 설정 한 위치와 연령이 \n다른 사용자에게 표시되며 \n닉네임은 모임마다 랜덤으로 생성됩니다."
        $0.font = .BasicFont(.regular, size: 14)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        joinDataManager.joinDelegate = self
        configureUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ageTextField.addUnderLine()
    }
    
    // MARK: - Selectors
    @objc func locationSetting() {
        getLocation()
    }
    
    @objc func textFieldDidChange() {
        if locationNameLabel.text != nil, ageTextField.text != nil {
            print("\(joinInfo.uid)")
            submitButton.backgroundColor = .mainYellow
            submitButton.isEnabled = true
        }
    }
    
    @objc func dismissAction() {
        self.view.endEditing(true)
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func submitJoin() {
        self.presentOkCancelAlert(title: "회원 가입", message: "가입을 진행하시겠습니까?", isCancelActionIncluded: true, preferredStyle: .alert) { action in
            self.joinDataManager.joinProcess(self.joinInfo, self.currentLatLon!)
            self.showIndicator()
        }
    }
   
    func getLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    func getLocationName() {
        let geocode = CLGeocoder()
        geocode.reverseGeocodeLocation(currentLocation) { (placemark, error) in
            guard
                let mark = placemark,
                let city = mark.first?.locality,
                let town = mark.first?.thoroughfare
            else {
                return
            }
            self.locationNameLabel.text = town
            self.locationNameLabel.textColor = .black
            self.joinInfo.city = city
            self.joinInfo.town = town
        }
    }
 
    
    func disableHidden(_ age: String) {
        self.gradeView = GradeButton(mode: .personalSetting, Int(age)!)
        bottomStackLayout()
        gradeView.isHidden = false
    }
}

extension PersonalSettingVC: JoinDelegate {
    func joinAction(_ error: String) {
        dismissIndicator()
        if error != "" {
            self.presentOkOnlyAlert(title: "가입 오류", message: "가입 도중 에러가 발생했습니다. 고객센터에 문의 바랍니다 \n \(error)")
        } else {
            moveToRoot(LocationVC())
        }
    }
}

extension PersonalSettingVC {
    func getYears() {
        let date = Date()
        let currentYear = Calendar.current.component(.year, from: date)
          
        for i in 19 ..< 50 {
            years.append(String(currentYear - i))
        }
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        ageTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.dismissAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        ageTextField.inputAccessoryView = toolBar
    }
}

extension PersonalSettingVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            currentLatLon = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.currentLocation = location
            getLocationName()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension PersonalSettingVC: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageTextField.text = years[row]
        joinInfo.age = Int(years[row]) ?? 0
        disableHidden(years[row])
    }
}

// MARK: Configure UI
extension PersonalSettingVC {
    func configureUI() {
        setting()
        layout()
    }
    
    func setting() {
        ageTextField.delegate = self
        topView.back.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        ageTextField.addTarget(self, action: #selector(textFieldDidChange), for: .allEvents)
        submitButton.addTarget(self, action: #selector(submitJoin), for: .touchUpInside)
        
        getYears()
        createPickerView()
        dismissPickerView()
        
        resultEmailLabel.text = joinInfo.email
        gradeView.isHidden = true
        submitButton.isEnabled = false
    }

    func layout() {
        view.addSubview(topView)
        view.addSubview(logoImage)
        view.addSubview(submitButton)
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(88))
        }
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom).offset(Device.heightScale(18))
            $0.width.equalTo(Device.widthScale(200))
            $0.height.equalTo(Device.heightScale(57.6))
        }
        submitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(85))
        }
        locationLayout()
        ageLayout()
        bottomStackLayout()
    }
    
    func locationLayout() {
        view.addSubview(locationTitleLabel)
        view.addSubview(locationNameLabel)
        view.addSubview(locationSetButton)
        view.addSubview(locationDescriptionLabel)
        
        locationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(Device.heightScale(117))
            $0.leading.equalToSuperview().offset(Device.widthScale(60))
        }
        
        locationNameLabel.snp.makeConstraints {
            $0.top.equalTo(locationTitleLabel.snp.top)
            $0.leading.equalTo(locationTitleLabel.snp.trailing).offset(Device.widthScale(35))
            $0.width.equalTo(Device.widthScale(Device.widthScale(100)))
        }
        
        locationSetButton.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(Device.heightScale(111))
            $0.leading.equalTo(locationNameLabel.snp.trailing).offset(15)
            $0.width.equalTo(Device.widthScale(65))
            $0.height.equalTo(Device.heightScale(27))
        }
        
        locationDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(locationNameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(locationNameLabel.snp.leading)
        }
    }
    
    func ageLayout() {
        view.addSubview(ageLabel)
        view.addSubview(ageTextField)
       
        ageLabel.snp.makeConstraints {
            $0.top.equalTo(locationTitleLabel.snp.bottom).offset(Device.heightScale(48))
            $0.trailing.equalTo(locationTitleLabel.snp.trailing)
        }
        
        ageTextField.snp.makeConstraints {
            $0.top.equalTo(locationNameLabel.snp.bottom).offset(Device.heightScale(48))
            $0.leading.equalTo(locationNameLabel.snp.leading)
            $0.width.equalTo(Device.widthScale(180))
        }
    }
    
    func bottomStackLayout() {
        view.addSubview(resultStackView)
        gradeViewCover.addSubview(gradeView)
        resultStackView.addArrangedSubview(resultEmailLabel)
        resultStackView.addArrangedSubview(gradeViewCover)
        
        resultStackView.addArrangedSubview(resultBottomLabel)
        resultStackView.addArrangedSubview(resultDescriptionLabel)
        
        resultStackView.snp.makeConstraints {
            $0.top.equalTo(ageLabel.snp.bottom).offset(Device.heightScale(70))
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        resultEmailLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(45))
        }
        
        gradeViewCover.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(33))
        }
        
        gradeView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(47)
            $0.height.equalTo(20)
            
        }
        
        resultBottomLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(45))
        }
        
        resultDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(127))
        }
    }
    
}
