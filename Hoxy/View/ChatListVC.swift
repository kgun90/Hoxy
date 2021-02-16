//
//  ChatVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit
import Firebase

class ChatListVC: BaseViewController, ChatListDataDelegate {

    
    // MARK: - Properties
    lazy var chatListTableView = UITableView().then {
        $0.backgroundColor = .mainBackground
    }
    var chatManager = ChatDataManager()
    var listData: [ChatListModel] = []
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "채팅"
        chatManager.listDelegate = self
        chatManager.getChats()
        layout()
        setting()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    func layout() {
        view.addSubview(chatListTableView)
        
        chatListTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    func setting() {
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
        chatListTableView.tableFooterView = UIView()
    }
   
    func getChatListData(_ chatListData: [ChatListModel]) {
        listData = chatListData
        print(listData)
        chatListTableView.reloadData()
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

        listData[indexPath.section].post?.addSnapshotListener({ (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    
                    let writer = data["writer"] as! DocumentReference
                    let nickname = self.listData[indexPath.section].member[writer.documentID] ?? ""
                    
                    cell.chatTitleLabel.text = "\(nickname)님의 모임"
                    cell.meetingPlaceLabel.text = data["town"] as? String
                    
                    let meetingTime = data["start"] as! Timestamp
                    cell.meetingTimeLabel.text = self.getMeetingTime(meetingTime.dateValue())
                }
            }
        })
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.heightScale(80)
    }
}
