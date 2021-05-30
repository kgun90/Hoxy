//
//  ChatRoomVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/14.
//

import UIKit
import Firebase
import BonsaiController



class ChatRoomVC: BaseViewController, ChatRoomDataDelegate, ChatRoomDelegate {
 

    // MARK: - Properties
    lazy var topInstructionView = UIView().then {
        $0.backgroundColor = .white
        $0.addSubview(topInstructionLabel)
        topInstructionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    lazy var topInstructionLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 15)
        $0.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "모든 모임대화는 모임 시간 이후 채팅이 불가하며 \n일주일 동안만 보관됩니다."
    }
    
    lazy var chatTableView = UITableView().then {
        $0.backgroundColor = .mainBackground
        $0.allowsSelection = false
        $0.separatorStyle = .none
    }
    
    lazy var chatInputView = UIView().then {
        $0.backgroundColor = .mainYellow
        $0.addSubview(chatInputTextField)
        $0.addSubview(chatSendButton)
        
        chatInputTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.heightScale(7))
            $0.leading.equalToSuperview().offset(Device.widthScale(Device.widthScale(14)))
            $0.height.equalTo(Device.heightScale(35))
            $0.width.equalTo(Device.widthScale(313))
        }
        
        chatSendButton.snp.makeConstraints {
            $0.centerY.equalTo(chatInputTextField.snp.centerY)
            $0.trailing.equalToSuperview().offset(Device.widthScale(-10))
            $0.width.equalTo(Device.widthScale(27))
            $0.height.equalTo(Device.heightScale(27))
        }
    }
    
    lazy var chatInputTextField = UITextField().then {
        $0.placeholder = "메세지 입력"
        $0.font = .BasicFont(.regular, size: 15)
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    lazy var chatSendButton = UIButton().then {
        $0.setImage(UIImage(systemName: "paperplane"), for: .normal)
        $0.tintColor = #colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)
        $0.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
    }
    var chatDataManager = ChatDataManager()
    var chatID: String = ""
    var postID: String = ""
    var chatData: [ChattingModel] = []
    var memberID = ""
    var nickname = ""
    var chatRoomMenu = ChatRoomMenuVC()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        chatDataManager.contentDelegate = self
        chatDataManager.getChattingData(chatID)
        setting()
        chatRoomMenu.delegate = self
        layout()
        addNaviButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        unregisterForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        topInstructionView.addBorder(toSide: .bottom, color: .labelGray, borderWidth: 0.3)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
  
    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardFrame: NSValue = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y = -keyboardRectangle.height
//            self.chatInputView.frame.origin.y = -keyboardRectaingle.height
        }
        
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func barButtonAction() {
        let vc = chatRoomMenu//ChatRoomMenuVC()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.postID = self.postID
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    @objc func sendButtonAction() {
        if let content = self.chatInputTextField.text, let uid = Auth.auth().currentUser?.uid {
            let sender = set.fs.collection(set.Table.member).document(uid)
            set.fs.collection(set.Table.chatting).document(chatID).collection("chat")
                .addDocument(data: [
                    "content" :  content,
                    "sender" : sender,
                    "date" : Date()
                ])
            self.chatInputTextField.text = ""
        }
    }
    
    func dismiss() {
        print("delegate")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Helpers
    func layout() {
        view.addSubview(topInstructionView)
        view.addSubview(chatTableView)
        view.addSubview(chatInputView)
        
        topInstructionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.topHeight)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(55))
        }
        chatTableView.snp.makeConstraints {
            $0.top.equalTo(topInstructionView.snp.bottom)//equalToSuperview().offset(Device.topHeight)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(chatInputView.snp.top)
        }
        chatInputView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(83))
        }
    }
    
    func addNaviButton() {
        let moreButton = UIBarButtonItem().then {
            $0.image = UIImage(systemName: "ellipsis")
            $0.target = self
            $0.action = #selector(barButtonAction)
        }
        
        navigationItem.rightBarButtonItem = moreButton
        
    }
    
    func setting() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "ChatMessageCell", bundle: nil), forCellReuseIdentifier: "ChatMessageCell")
    }
    
    func getChatContentData(_ chatData: [ChattingModel]) {
        set.fs.collection(set.Table.post).document(postID).addSnapshotListener { (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    self.navigationItem.title = data["title"] as? String
                }
            }
        }
        self.chatData = chatData
        self.chatTableView.reloadData()

        self.chatTableView.scrollToBottom()
    }
    
    
}

extension ChatRoomVC: UITableViewDataSource, UITableViewDelegate {
    @objc func cellButtonAction(sender: UIButton) {
        let content = sender.superview?.superview
        let cell = content?.superview as! ChatMessageCell
       
        let vc = ChatRoomProfileVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.userID = cell.senderID
        vc.nickname = cell.senderNickname
        vc.chatID = self.chatID
        present(vc, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10//chatData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath as IndexPath) as! ChatMessageCell
        cell.contentLabel.text = ""//chatData[indexPath.section].content

       chatData[indexPath.section].sender?.addSnapshotListener({ (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                let id = snapshot?.documentID
        
                if id == Auth.auth().currentUser?.uid {
                    cell.contentFrameView.backgroundColor = .mainYellow
                    cell.emojiButton.isHidden = true
                    cell.nicknameLabel.isHidden = true

                } else {
                    cell.contentFrameView.backgroundColor = .white
                    cell.emojiButton.isHidden = false
                    cell.nicknameLabel.isHidden = false

                }
                
                if let data = snapshot?.data() {
                    cell.emojiButton.setTitle(data["emoji"] as? String, for: .normal)
                    cell.emojiButton.addTarget(self, action: #selector(self.cellButtonAction(sender:)), for: .touchUpInside)
                }
                set.fs.collection(set.Table.chatting)
                    .document(self.chatID)
                    .addSnapshotListener { (snapshot, error) in
                        if let e = error {
                            print(e.localizedDescription)
                        } else {
                            if let data = snapshot?.data() {
                                let member = data["nickname"] as! [String: String]
                                cell.nicknameLabel.text = member[id ?? ""]
                                cell.senderNickname = member[id!]!
                                cell.senderID = id!
                            }
                        }
                }
            }
        })
        return cell
    }
}

extension ChatRoomVC: BonsaiControllerDelegate {
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: Device.widthScale(88), y: containerViewFrame.height * 0.11), size: CGSize(width: Device.widthScale(287), height: containerViewFrame.height ))
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let blurEffectStyle = UIBlurEffect.Style.systemThinMaterialDark
        
        return BonsaiController(fromDirection: .right, blurEffectStyle: blurEffectStyle, presentedViewController: presented, delegate: self)
        
    }
}
