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
    private var blockData = [BlockModel]()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "만남거부목록"
        view.backgroundColor = .mainBackground
        getBlockListData()
        configureUI()
    }
    // MARK: - Selectors
    
    // MARK: - Helpers
    func getBlockListData() {
        UserDataManager.getBanListData { data in
            self.blockData = data
            self.reloadTable()
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
}

extension BlockUserListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "BlockUserCell") as! BlockUserCell
        cell.data = blockData[indexPath.row]
        return cell
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
    }
    
    func layout() {
        view.addSubview(topInstructionView)
        topInstructionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Device.topHeight)
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(Device.heightScale(40))
        }
    }
}
