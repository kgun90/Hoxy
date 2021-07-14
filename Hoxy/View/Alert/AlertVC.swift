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
    
    private let guideLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 14)
        $0.textColor = .labelGray
        $0.text = "알람이 없습니다"
    }
    
    private var alertData = [AlertModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissIndicator()
    }
    
    func fetchData() {
        AlertDataManager.getAlertData { data in
            self.alertData = data
            self.reloadTable()
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.alertListTableView.reloadData()
        }
        setting() 
    }
    
    func selectAction(chatID: String) {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let vc = TabBarController()
        vc.selectedIndex = 2
        vc.isFromNotification = true
        vc.uid = chatID
        window.rootViewController = vc
        window.makeKeyAndVisible()

        UIView.transition(with: window, duration: 0.1, options: [.transitionCrossDissolve], animations: nil)
    }
}

extension AlertVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = alertListTableView.dequeueReusableCell(withIdentifier: "AlertItemTableCell", for: indexPath as IndexPath) as! AlertItemTableCell
        
        cell.data = alertData[indexPath.row]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        
        return cell        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.heightScale(80)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = alertData[indexPath.row].type
        
        if type == "apply" {
            Constants.CHAT_COLLECTION.document(alertData[indexPath.row].target).getDocument { snapshot, error in
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                guard let data = snapshot?.data() else { return }
                let chatData = ChattingModel(dictionary: data)
                chatData.post.getDocument { snapshot, error in
                    if let e = error {
                        print(e.localizedDescription)
                        return
                    }
                    guard let id = snapshot?.documentID else { return }
                    guard let data = snapshot?.data() else { return }
                    let post = PostDataModel(uid: id, dictionary: data)
                    
                    if post.start.isExpired {
                        self.presentOkOnlyAlert(title: "유효기간이 지난 모임은 채팅방으로 이동하지 않습니다")
                    } else {
                        self.selectAction(chatID: self.alertData[indexPath.row].target)
                    }
                }
                
            }
        } else if type == "time" {
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    } // Edit 모드 사용여부(Swipe 등)
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            self.askDelete(documentID: alertData[indexPath.row].id)
        }
       
    } // TableView Cell Swipe하여 삭제
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
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
        guideLabel.isHidden = alertData.count > 0 ? true : false
    }
    
    func layout() {
        view.addSubview(alertListTableView)
        view.addSubview(guideLabel)
        
        guideLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        alertListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
}
