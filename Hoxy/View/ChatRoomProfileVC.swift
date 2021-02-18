//
//  ChatRoomProfileVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/19.
//

import UIKit

class ChatRoomProfileVC: UIViewController {
    // MARK: - Properties
    lazy var dismissButton = UIButton().then {
        $0.setImage(UIImage(systemName: "multiply"), for: .normal)
        $0.tintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        $0.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    
    lazy var label = UILabel().then {
        $0.font = .BasicFont(.bold, size: 20)
        $0.textColor = .black
        
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainYellow
        layout()
    }
    // MARK: - Selectors
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Helpers
    func layout() {
        view.addSubview(dismissButton)
        view.addSubview(label)
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.topHeight)
            $0.leading.equalToSuperview().offset(Device.widthScale(15))
            $0.height.equalTo(Device.heightScale(25))
            $0.width.equalTo(Device.widthScale(25))
        }
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
   
}
