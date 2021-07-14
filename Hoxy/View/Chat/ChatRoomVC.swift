//
//  ChatRoomVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/02/14.
//

import UIKit
import Firebase
import BonsaiController



class ChatRoomVC: BaseViewController {
 
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
        $0.text = "모든 모임대화는 모임 종료 + 12시간 이후 채팅이 불가하며 \n일주일 동안만 보관됩니다"
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
            $0.leading.equalToSuperview().offset(Device.widthScale(14))
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
        $0.addLeftPadding()
        $0.layer.cornerRadius = 10
    }
    
    lazy var chatSendButton = UIButton().then {
        $0.setImage(UIImage(systemName: "paperplane"), for: .normal)
        $0.tintColor = #colorLiteral(red: 0.5764705882, green: 0.5843137255, blue: 0.5921568627, alpha: 1)
        $0.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
    }
    
    var chatID: String = ""
    var postID: String = ""
    
    var postData: PostDataModel?
    
    var chatData: [ChatModel]?

    var chatRoomMenu = ChatRoomMenuVC()
    
    var viewModel = ChatViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dismissIndicator()
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
//            chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
//            self.chatInputView.frame.origin.y = -keyboardHeight
        }
        
    }

    
    @objc func keyboardWillHide(note: NSNotification) {
        self.view.frame.origin.y = 0
//        chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        self.chatInputView.frame.origin.y = 0
    }
    
    @objc func barButtonAction() {
        let vc = chatRoomMenu
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.postID = self.postID
        vc.chatID = self.chatID
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    @objc func sendButtonAction() {
        if chatInputTextField.text != "" {
            ChatDataManager.sendChat(content: self.chatInputTextField.text ?? "", chatID: chatID)
            self.chatInputTextField.text = ""
        }
       
    }
    
    // MARK: - Helpers
   
    func fetchChat() {
        ChatDataManager.getChatData(byId: chatID) { chats in
            self.chatData = chats
            self.reloadTable()
        }
    }
        
    func reloadTable() {
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
            self.chatTableView.scrollToBottom()
        }
    }
    
}

extension ChatRoomVC: UITextFieldDelegate {
    // 키보드 영역 이외 터치시 키보드 해제
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let post = self.postData else { return }
        if post.start.isExpired {
            self.chatInputTextField.isEnabled = false
            presentOkOnlyAlert(title: "기간이 만료되어 채팅이 불가합니다")
        }
    }
}

extension ChatRoomVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = getCellType(from: tableView, indexPath, (chatData?[indexPath.row].sender.documentID)!)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return topInstructionView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func getCellType(from tableView: UITableView, _ indexPath: IndexPath, _ id: String) -> UITableViewCell {
        var cell = UITableViewCell()

        if id == Auth.auth().currentUser?.uid {
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell") as? MyMessageCell else { return cell }
            messageCell.chatData = chatData?[indexPath.row]
            cell = messageCell
        } else {
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell") as? ChatMessageCell else { return cell }
            messageCell.delegate = self
            messageCell.chatID = self.chatID
            messageCell.chatData = chatData?[indexPath.row]
            cell = messageCell
        }
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

extension ChatRoomVC {
    func configureUI() {
        fetchChat()
        binding()
        setting()
        layout()
        addNaviButton()
    }
    
    func binding() {
//        viewModel.roomTitle.bind { [weak self] data in
//            self?.navigationItem.title = data
//        }
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
        chatRoomMenu.delegate = self
        chatInputTextField.delegate = self
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        chatTableView.register(UINib(nibName: "ChatMessageCell", bundle: nil), forCellReuseIdentifier: "ChatMessageCell")
        chatTableView.register(UINib(nibName: "MyMessageCell", bundle: nil), forCellReuseIdentifier: "MyMessageCell")
        chatTableView.keyboardDismissMode = .interactive
        
        ChatDataManager.getChattingData(byID: chatID) { model in
            self.postID = model.post.documentID
            self.getRoomTitle(self.postID)
        }
    }
    
    
    func getRoomTitle(_ postID: String) {
        PostDataManager.getPostData(byID: postID) { data in
            self.postData = data
            self.navigationItem.title = data.title
        }
    }
    
    func layout() {
        view.addSubview(chatTableView)
        view.addSubview(chatInputView)

        chatTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(Device.heightScale(-83))//equalTo(chatInputView.snp.top)
        }
        chatInputView.snp.makeConstraints {
            $0.height.equalTo(Device.heightScale(83))
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}
extension ChatRoomVC: ChatRoomMenuDelegate {
    func dismiss(postID: String) {
        if postID != "" {
            let vc = PostVC()
            vc.postID = postID
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
      
    }
}

extension ChatRoomVC: ChateMessageCellDelegate {
    func showChatUserProfile(senderInfo: SenderInfoModel) {
        let vc = ChatRoomProfileVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.senderInfo = senderInfo
        vc.chatID = self.chatID
        present(vc, animated: true, completion: nil)
    }
    
}
