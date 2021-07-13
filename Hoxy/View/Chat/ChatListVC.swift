//
//  ChatVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit
import Firebase

class ChatListVC: BaseViewController {
    // MARK: - Properties
    lazy var chatListTableView = UITableView().then {
        $0.backgroundColor = .mainBackground
    }
    
    private let guideLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 14)
        $0.textColor = .labelGray
        $0.text = "채팅이 없습니다"
    }
    var listData: [ChatListModel] = []
    var viewModel = ChatViewModel()

    var isPushNotification: Bool?
    var chatID = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "채팅"
//        viewModel.getChatListData()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel.getChatListData()
        getChatListData()
        
        if isPushNotification != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.fromPushAction()
            }
            
            isPushNotification = nil
        }
    }
    // MARK: - Selectors
    
    // MARK: - Helpers
    func readChatRoom(_ data: ChatListModel) {
            let vc = ChatRoomVC()
            vc.chatID = data.id
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fromPushAction() {
        let vc = ChatRoomVC()
        if chatID != "" {
            vc.chatID = chatID
        }
        
        Log.any(chatID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.chatListTableView.reloadData()
        }
        setting()
    }
}


extension ChatListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
        
    } 

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath as IndexPath) as! ChatListTableViewCell
        cell.chatData = listData[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.heightScale(80)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showIndicator()
        readChatRoom(listData[indexPath.row])
    }
}

extension ChatListVC {
    func configureUI() {
       
        getChatListData()
        setting()
        layout()
    }
    
    func getChatListData() {
        ChatDataManager.getChats { data in
                self.listData = data
                self.reloadTableView()
        }
    }
    
    func setting() {
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
        chatListTableView.tableFooterView = UIView()
        
        guideLabel.isHidden = listData.count > 0 ? true : false
    }
    
    func layout() {
        view.addSubview(chatListTableView)
        view.addSubview(guideLabel)
        
        guideLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        chatListTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
   
    
}
