//
//  HomeVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit
import Firebase
import BTNavigationDropdownMenu

class HomeVC: BaseViewController {
    // MARK: - Properties
    private var viewModel = HomeViewModel()
    private var posts = [PostDataModel]()
    private var manager = LocationManager()
       
    private var items: [String] = []
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
    
    private let guideLabel = UILabel().then {
        $0.font = .BasicFont(.regular, size: 14)
        $0.textColor = .labelGray
        $0.text = "모임이 없습니다"
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        viewModel.fetchPostsData()
        initRefresh()
        configureUI()
    }

    
    // MARK: - Selectors
    @objc func moveToWrite() {
        let vc = WriteVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPostsData()
        viewModel.getMenuItem()
        showIndicator()
    }
    // MARK: - Logics
   
    
    func dropdownMenu() {
        let menuView = BTNavigationDropdownMenu(title: BTTitle.index(0), items: items)
        self.navigationItem.titleView = menuView

        menuView.cellBackgroundColor = .white
        menuView.arrowTintColor = .black
        menuView.checkMarkImage.withTintColor(.black)
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self!.viewModel.locationChangeAction(self!.posts, indexPath)
        }
    }
    
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh: )), for: .valueChanged)
//        refresh.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        
        if #available(iOS 10.0, *) {
            listTableView.refreshControl = refresh
        } else {
            listTableView.addSubview(refresh)
        }
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        reloadTable()
//        viewModel.currentLocation()
        viewModel.getMenuItem()
        
        refresh.endRefreshing()
    }
    
    func readPost(_ id: String) {
        let vc = PostVC()
        vc.postID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
        setting()
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
       
        cell.postData = posts[indexPath.section]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.heightScale(100)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        readPost(posts[indexPath.section].id)
        viewModel.addViewCount(posts[indexPath.section].id, posts[indexPath.section].view)
    }
}

// MARK: Configure UI
extension HomeVC {
    func configureUI() {
        binding()
        setting()
        layout()
    }
    
    func binding() {
        viewModel.postData.bind { [weak self] data in
            self?.posts = data
            self?.reloadTable()
            self?.dismissIndicator()
        }
        viewModel.menuItem.bind { [weak self] data in
            self?.items = data
            self?.dropdownMenu()
        }
    }
    
    func setting() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        listTableView.tableFooterView = UIView()
        
        guideLabel.isHidden = posts.count > 0 ? true : false
    }
    
    func layout() {
        view.addSubview(listTableView)
        view.addSubview(writeButton)
        view.bringSubviewToFront(writeButton)
        view.addSubview(guideLabel)
        
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
        
        guideLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
