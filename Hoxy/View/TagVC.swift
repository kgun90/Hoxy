//
//  TagVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/01.
//

import UIKit

class TagVC: UIViewController, RequestTagProtocol{

    // MARK: - Properties
    let topView = TopView("태그추가", .mainYellow, "multiply")
    lazy var tagListTableView = UITableView()
    var tagList = [TagModel()]
    var dataManager = TagDataManager()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dataManager.delegate = self
        dataManager.requestTagList()
        
    }
    // MARK: - Selectors
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Helpers
    func getTagList(_ tagDataList: [TagModel]) {
        print("getTagList: \(tagDataList)")
        tagList = tagDataList
        reloadTable()
    }
    func reloadTable() {
        DispatchQueue.main.async {
            self.tagListTableView.reloadData()
        }
    }
}

extension TagVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tagListTableView.dequeueReusableCell(withIdentifier: "TagListTableViewCell") as! TagListTableViewCell
        cell.tagLabel.text = tagList[indexPath.row].name
        cell.countLabel.text = String(tagList[indexPath.row].count)
        return cell
    }
}

extension TagVC {
    func configureUI() {
        layout()
        setting()
    }
    func setting() {
        topView.back.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        tagListTableView.dataSource = self
        tagListTableView.delegate = self
        tagListTableView.register(UINib(nibName: "TagListTableViewCell", bundle: nil), forCellReuseIdentifier: "TagListTableViewCell")
    }
    
    func layout() {
        view.addSubview(topView)
        view.addSubview(tagListTableView)
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(88))
        }
        tagListTableView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(199)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
