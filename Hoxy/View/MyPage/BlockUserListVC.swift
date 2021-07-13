//
//  BlockUserListVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/07/02.
//

import UIKit

class BlockUserListVC: BaseViewController {
    // MARK: - Properties
    lazy var topInstructionView = UIView().then {
        $0.backgroundColor = .white
        $0.addSubview(topInstructionLabel)
        topInstructionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    lazy var topInstructionLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 12)
        $0.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "아래 목록의 회원들과 서로의 게시글이 표시되지 않습니다"
    }
    
    private let listTableView = UITableView().then {
        $0.backgroundColor = .mainBackground
    }
    
    private let guideLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 14)
        $0.textColor = .labelGray
        $0.text = "만남거부 목록이 없습니다"
    }

    private var blockData = [BlockModel]()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "만남거부목록"
        view.backgroundColor = .mainBackground
        getBlockListData()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        topInstructionView.addBorder(toSide: .bottom, color: .mainBackground, borderWidth: 0.5)
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    func getBlockListData() {
        blockData = []
        UserDataManager.getBanListData { data in
            self.blockData = data
            self.reloadTable()
        }
    }
    
    func askDelete(documentID: String) {
        let action = UIAlertAction(title: "확인", style: .default) { action in
            ChatDataManager.unblockUser(byID: documentID)
            self.getBlockListData()
        }
        presentAlert(title: "차단 사용자 삭제", message: "차단목록에서 삭제하시겠습니까?", isCancelActionIncluded: true, preferredStyle: .alert, with: action)
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
        setting()
    }
}

extension BlockUserListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "BlockUserCell", for: indexPath as IndexPath) as! BlockUserCell
        cell.data = blockData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    } // Edit 모드 사용여부(Swipe 등)
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.askDelete(documentID: blockData[indexPath.row].id)
        }
       
    } // TableView Cell Swipe하여 삭제
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}

extension BlockUserListVC {
    func configureUI() {
        layout()
        setting()
    }
    
    func setting() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: "BlockUserCell", bundle: nil), forCellReuseIdentifier: "BlockUserCell")
        listTableView.tableFooterView = UIView()
        
        guideLabel.isHidden = blockData.count > 0 ? true : false
    }
    
    func layout() {
        view.addSubview(topInstructionView)
        view.addSubview(listTableView)
        listTableView.addSubview(guideLabel)
        topInstructionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.topHeight)
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(Device.heightScale(40))
        }
        listTableView.snp.makeConstraints {
            $0.top.equalTo(topInstructionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        guideLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
