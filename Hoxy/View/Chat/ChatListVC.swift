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
    
    var listData = [ChatListModel]()
    var viewModel = ChatViewModel()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "채팅"
        viewModel.getChatListData()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getChatListData()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    func readChatRoom(_ data: ChatListModel) {
        let vc = ChatRoomVC()
        vc.chatID = data.id
        vc.postID = data.chat.post.documentID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.chatListTableView.reloadData()
        }
    }
}

extension ChatListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return listData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.chatListTableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath as IndexPath) as! ChatListTableViewCell
        
        cell.chatData = listData[indexPath.section]
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.heightScale(80)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        readChatRoom(listData[indexPath.section])
    }
}

extension ChatListVC {
    func configureUI() {
        binding()
        setting()
        layout()
    }
    
    func binding() {
        viewModel.chatListData.bind { [weak self] data in
            self?.listData = data
            self?.reloadTableView()
        }
    }
    
    func setting() {
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
        chatListTableView.tableFooterView = UIView()
    }
    
    func layout() {
        view.addSubview(chatListTableView)
        
        chatListTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
   
    
}
