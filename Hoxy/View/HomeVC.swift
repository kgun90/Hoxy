//
//  HomeVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit
import Firebase

class HomeVC: BaseViewController, PostDataDelegate {


    
    // MARK: - Properties
    lazy var listTableView = UITableView().then {
        $0.backgroundColor = .mainBackground
    }
    lazy var writeButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: Device.widthScale(55), height:  Device.heightScale(55))
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.layer.cornerRadius = $0.frame.size.height / 2
        $0.backgroundColor = .mainYellow
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(moveToWrite), for: .touchUpInside)
    }
    var postDataManager = PostDataManager()
    var posts: [PostDataModel] = []
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        layout()
        postDataManager.delegate = self
        postDataManager.requestPostData()
       
    }
    // MARK: - Selectors
    @objc func moveToWrite() {
        let vc = WriteVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
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
        view.addSubview(writeButton)
        view.bringSubviewToFront(writeButton)
        listTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
            $0.center.equalToSuperview()
        }
        writeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-(Device.tabBarHeight + Device.heightScale(46)))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-30))
            $0.width.equalTo(Device.widthScale(55))
            $0.height.equalTo(Device.heightScale(55))
        }
    }
    
    func getPostData(_ postData: [PostDataModel]) {
        posts = postData
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
        for data in posts {
            print(data.tag)
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
        return posts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.listTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath as IndexPath) as! HomeTableViewCell
        cell.emojiLable.text = posts[indexPath.section].emoji
        cell.titleLabel.text = posts[indexPath.section].title
        cell.locationLabel.text = posts[indexPath.section].town
        cell.writeTimeLabel.text = posts[indexPath.section].date.relativeTime_abbreviated
        cell.viewsLabel.text = String(posts[indexPath.section].view)
//        cell.meetingTimeLabel.text = posts[indexPath.section].start
        cell.attenderCountLabel.text = String(posts[indexPath.section].headcount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.heightScale(100)
    }
    
    
}
