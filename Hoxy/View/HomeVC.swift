//
//  HomeVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit

class HomeVC: BaseViewController {
    
    // MARK: - Properties
    lazy var listTableView = UITableView().then {
        $0.backgroundColor = .mainBackground
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
    }
    // MARK: - Selectors
    // MARK: - Logics
    func setting() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        listTableView.tableFooterView = UIView()
    }
    // MARK: - Helpers
    func layout() {
        view.addSubview(listTableView)
        
        listTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
    func menuHandler(action: UIAction) {
        Swift.debugPrint("Menu handler: \(action.title)")
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("Copy", comment: ""), image: UIImage(systemName: "doc.on.doc"), handler: menuHandler),
            UIAction(title: NSLocalizedString("Rename", comment: ""), image: UIImage(systemName: "pencil"), handler: menuHandler),
            UIAction(title: NSLocalizedString("Duplicate", comment: ""), image: UIImage(systemName: "plus.square.on.square"), handler: menuHandler),
            UIAction(title: NSLocalizedString("Move", comment: ""), image: UIImage(systemName: "folder"), handler: menuHandler)
        ])
        if #available(iOS 14.0, *) {
            navigationController?.navigationItem.leftBarButtonItem?.menu = barButtonMenu
        } else {
            // Fallback on earlier versions
        }
    }

}
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.listTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath as IndexPath) as! HomeTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.heightScale(100)
    }
    
    
}
