//
//  UnKnownVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit

class AlertVC: BaseViewController {
    
    lazy var alertListTableView = UITableView().then {
        $0.backgroundColor = .mainBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
}

extension AlertVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = alertListTableView.dequeueReusableCell(withIdentifier: "AlertItemTableCell", for: indexPath as IndexPath) as! AlertItemTableCell
        
        cell.lblEmoji.text = "👍"
        cell.lblTitle.text =  "강건님의 새 메시지"
        cell.lblMessage.text = "test message"
        cell.lblDate.text = "1일 전"
        cell.setTitle("강건")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.heightScale(80)
    }
    
}

extension AlertVC {
    func configureUI() {
        layout()
        setting()
    }
    
    func setting() {
        navigationItem.title = "알림"
        alertListTableView.delegate = self
        alertListTableView.dataSource = self
        alertListTableView.register(UINib(nibName: "AlertItemTableCell", bundle: nil), forCellReuseIdentifier: "AlertItemTableCell")
        alertListTableView.tableFooterView = UIView()
    }
    
    func layout() {
        view.addSubview(alertListTableView)
        
        alertListTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
            $0.center.equalToSuperview()
        }
        
        
    }
}
