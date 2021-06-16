//
//  TagVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/01.
//

import UIKit

protocol TagDelegate {
    func getTagList(_ tagList: [TagModel])
}

enum KeyTyping {
    case on, off
    
    mutating func toggle() {
        switch self {
        case .on:
            self = .off
        case .off:
            self = .on
        }
    }
}

class TagVC: UIViewController, RequestTagProtocol{
    var delegate: TagDelegate?
    
    var state: Bool = false
    
    // MARK: - Properties
    let topView = TopView("태그추가", .mainYellow, "multiply")
    lazy var tagPostButton = UIButton().then {
        $0.setTitle("등록", for: .normal)
        $0.titleLabel?.font = .BasicFont(.medium, size: 15)
        $0.addTarget(self, action: #selector(tagPostAction), for: .touchUpInside)
        $0.tintColor = .hashtagBlue
    }
    
    lazy var tagListTableView = UITableView()
    
    lazy var tagScrollView = UIScrollView().then {
        $0.backgroundColor = .init(hex: 0xDDDDDD)
        $0.showsHorizontalScrollIndicator = false
    }
    
    lazy var contentView = UIStackView().then {
        $0.backgroundColor = .init(hex: 0xDDDDDD)
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 10
    }
    
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
 
        tagTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Device.widthScale(47))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-30))
        }
       
    }

    lazy var tagTextField = UITextField().then {
        $0.font = .BasicFont(.medium, size: 12)
        $0.textColor = .hashtagBlue
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
        
    var tagList = [TagModel]()
    var oriTagList = [TagModel]()
    var dataManager = TagDataManager()
    var tagData = [TagModel]()
    
    var keyState: KeyTyping = .off
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
    @objc func tagPostAction() {
        self.dismiss(animated: true) {
            self.delegate?.getTagList(self.tagData)
            
        }
    }
    // MARK: - Helpers
    func getTagList(_ tagDataList: [TagModel]) {
        tagList = tagDataList
        oriTagList = tagDataList
        reloadTable()
    }
    
    func reloadTable() {
        tagList = tagList.sorted(by: { $0.count! > $1.count!})
        DispatchQueue.main.async {
            self.tagListTableView.reloadData()
        }
    }
    
    func addTagAction(_ model: TagModel) {
        if tagData.count < 5{
            tagList = tagList.filter({ $0.name != model.name })
            tagData.append(model)
            
            let tag = TagItem(model.name!, button: true)
            tag.tagButton.title = model.name
            tag.tagButton.count = model.count
            tag.tagButton.addTarget(self, action: #selector(tagRemoveButtonPressed(_:)), for: .touchUpInside)
            
            contentView.addArrangedSubview(tag)
            
            tagScrollView.scroll(to: .right)
        }
        
        tagTextField.text = ""
        print("tagData: \(tagData)")
    }
    
    @objc func tagRemoveButtonPressed(_ sender: RemoveButton){
        guard let tagView = sender.superview?.superview else { return }
        tagData = tagData.filter({ $0.name != sender.title })
        oriTagList.forEach {
            if $0.name == sender.title {
                tagList.append(TagModel(name: sender.title, count: sender.count))
            }
        }
      
        tagView.removeFromSuperview()
        reloadTable()
    }
    
    @objc func textFieldDidChange() {        
        if tagTextField.text == "" {
            tagList = oriTagList
        } else {
            
            tagList.insert(TagModel(name: tagTextField.text, count: 0), at: 0)
            tagList = oriTagList.filter({
                $0.name == tagTextField.text
            })
        }
        tagList.removeFirst()
        reloadTable()
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
        let model = TagModel(name: tagList[indexPath.row].name, count: tagList[indexPath.row].count)
        addTagAction(model)
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
        view.addSubview(tfView)
        view.addSubview(tagListTableView)
        topView.addSubview(tagPostButton)
        tagListLayout()
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(Device.heightScale(88))
        }

        tagPostButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(Device.widthScale(-30))
            $0.centerY.equalTo(topView.back.snp.centerY)
        }
        
        tfView.snp.makeConstraints {
            $0.top.equalTo(tagScrollView.snp.bottom)
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
    
    func tagListLayout() {
        view.addSubview(tagScrollView)
        tagScrollView.addSubview(contentView)
        
        tagScrollView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(Device.heightScale(50))
        }
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(Device.heightScale(30))
            $0.leading.equalToSuperview().offset(Device.widthScale(10))
            $0.trailing.equalToSuperview().offset(Device.widthScale(-10))
            $0.centerY.equalToSuperview()
        }
        
    }
}

