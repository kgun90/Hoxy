//
//  TagVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/01.
//

import UIKit

class TagVC: UIViewController {
    // MARK: - Properties
    let topView = TopView("태그추가", .mainYellow, "multiply")
    lazy var tagListTableView = UITableView()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - Selectors
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Helpers
   
}

extension TagVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tagListTableView.dequeueReusableCell(withIdentifier: "TagListTableViewCell") as! TagListTableViewCell
        cell.tagLabel.text = "풍덕천동"
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
