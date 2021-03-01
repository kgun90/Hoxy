//
//  HomeVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit
import Firebase
import CoreLocation
import BTNavigationDropdownMenu

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
    var id: String?
//    var location = CLLocation()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator()
        postDataManager.delegate = self
        postDataManager.requestPostData()
        setting()
        layout()
        dropdownMenu()
        initRefresh()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    
    func dropdownMenu() {
        let menuView = BTNavigationDropdownMenu(title: BTTitle.index(0), items: [LocationService.currentTown, LocationService.userTown])
        self.navigationItem.titleView = menuView
     
        menuView.cellBackgroundColor = .white
        menuView.arrowTintColor = .black
        menuView.checkMarkImage.withTintColor(.black)
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self!.locationChangeAction(indexPath)
        }
    }
    
    func locationChangeAction(_ index: Int) {
        showIndicator()
        listTableView.reloadData()
        if index == 0 {
            posts = posts.filter ({ (post: PostDataModel) -> Bool in
                let location = CLLocation(latitude: post.location!.latitude, longitude: post.location!.longitude)
                return location.distance(from: LocationService.currentLocation!) < 5000
            })
        } else {
            posts = posts.filter ({ (post: PostDataModel) -> Bool in
                let location = CLLocation(latitude: post.location!.latitude, longitude: post.location!.longitude)
                return location.distance(from: LocationService.userLocation!) < 5000
            })
        }
  

        listTableView.reloadData()
        dismissIndicator()
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
        self.listTableView.reloadData()
        self.dismissIndicator()
    }
    
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh: )), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        
        if #available(iOS 10.0, *) {
            listTableView.refreshControl = refresh
        } else {
            listTableView.addSubview(refresh)
        }
        
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        listTableView.reloadData()
    }
    
    func readPost(_ id: String) {
        let vc = PostVC()
        vc.postID = id
        self.navigationController?.pushViewController(vc, animated: true)
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
        cell.meetingTimeLabel.text = getMeetingTime(posts[indexPath.section].start, posts[indexPath.section].duration)
       
        posts[indexPath.section].writer?.addSnapshotListener({ (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    let birth = data["birth"] as! Int
                    cell.gradeButton.getGrade(.tableCell, birth)
                }
            }
        })

        posts[indexPath.section].chat?.addSnapshotListener({ (snapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    let memberCount = (data["nickname"] as! [String : String]).count
                    cell.attenderCountLabel.text = " \(memberCount)/\(self.posts[indexPath.section].headcount)"
                }
            }
        })

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.heightScale(100)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        readPost(posts[indexPath.section].id)
        id = posts[indexPath.section].id
        set.fs.collection(set.Table.post).document(posts[indexPath.section].id).updateData([
            "view": posts[indexPath.section].view + 1
        ])
    }
    
    
}
