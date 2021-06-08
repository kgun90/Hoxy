//
//  TagVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/01.
//

import UIKit
import TagListView

class TagVC: UIViewController, RequestTagProtocol{

    @IBOutlet weak var tagListView: TagListView!
    // MARK: - Properties
    let topView = TopView("태그추가", .mainYellow, "multiply")
    lazy var tagListTableView = UITableView()
    lazy var tfView = UIView().then {
        $0.backgroundColor = .backgroundGray
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: "tag")
        iv.tintColor = UIColor(hex: 0xcbcbcb)
        
        $0.addSubview(iv)
        
        iv.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(20))
            $0.width.equalTo(Device.widthScale(24))
            $0.height.equalTo(Device.heightScale(24))
        }
        
        $0.addSubview(tagTextField)
        $0.addSubview(tagAddButton)
        tagTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(47))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-80))
        }
        tagAddButton.snp.makeConstraints {
            $0.leading.equalTo(tagTextField.snp.trailing).offset(5)
            $0.width.equalTo(Device.widthScale(50))
            $0.height.equalTo(tagTextField.snp.height)
            $0.bottom.equalTo(tagTextField.snp.bottom)
        }
    }

    lazy var tagTextField = UITextField().then {
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .hashtagBlue
    }
    lazy var tagAddButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.titleLabel?.font = .BasicFont(.medium, size: 15)
        $0.titleLabel?.textColor = .white
        $0.backgroundColor = .hashtagBlue
        $0.layer.cornerRadius = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(addTagAction), for: .touchUpInside)
    }

    
    var tagList = [TagModel]()
    var dataManager = TagDataManager()
    var tagData: [String] = []
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dataManager.delegate = self
        dataManager.requestTagList()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagTextField.addUnderLine(color: 0xcbcbcb)
    }
    
    // MARK: - Selectors
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Helpers
    func getTagList(_ tagDataList: [TagModel]) {
        tagList = tagDataList
        reloadTable()
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tagListTableView.reloadData()
        }
    }
    
    @objc func addTagAction() {
        if tagData.count < 5 {
            tagListView.addTag(tagTextField.text!)
            tagData.append(tagTextField.text!)
        }
        tagTextField.text = ""
        print("tagData: \(tagData)")
    }
}

extension TagVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tagListTableView.dequeueReusableCell(withIdentifier: "TagListTableViewCell") as! TagListTableViewCell
        cell.tagLabel.text = tagList[indexPath.row].name
        cell.countLabel.text = String(tagList[indexPath.row].count ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tagData.count < 5 {
            tagListView.addTag(tagList[indexPath.row].name!)
            tagList.remove(at: indexPath.row)
        }
       
        reloadTable()
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
        tagListView.backgroundColor = .mainBackground
    }
    
    func layout() {
        view.addSubview(topView)
        view.addSubview(tfView)
        view.addSubview(tagListTableView)
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(88))
        }
        tagListView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Device.heightScale(90))
        }
        tfView.snp.makeConstraints {
            $0.top.equalTo(tagListView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(50))
        }
        tagListTableView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tfView.snp.bottom)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
