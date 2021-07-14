//
//  TagVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/01.
//

import UIKit

protocol TagDelegate {
    func getTagList(_ tagList: [String])
}

class TagVC: UIViewController {
    var delegate: TagDelegate?
        
    // MARK: - Properties
    let topView = TopView("태그추가", .mainYellow, imageTitle: "multiply")
    lazy var tagPostButton = UIButton().then {
        $0.setTitle("등록", for: .normal)
        $0.titleLabel?.font = .BasicFont(.medium, size: 15)
        $0.addTarget(self, action: #selector(tagPostAction), for: .touchUpInside)
        $0.setTitleColor(.black, for: .normal)
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
        $0.spacing = Device.widthScale(10)
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
    
    var viewModel = TagViewModel()
    
    var tagList = [TagModel]()
    var oriTagList = [TagModel]()
    var dataManager = TagDataManager()
    var tagData = [String]()
    
    var alertModel = TagAlertModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.requestTagList()
        configureUI()       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTagStack()
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
        let action = UIAlertAction(title: "확인", style: .default) { (action) in
            self.dismiss(animated: true) {
                self.delegate?.getTagList(self.tagData)
            }
        }
        presentAlert(title: "태그 등록", message: "태그를 등록하시겠습니까?", isCancelActionIncluded: true, preferredStyle: .alert, with: action)
        
    }
    // MARK: - Helpers
    func reloadTable() {
        DispatchQueue.main.async {
            self.tagListTableView.reloadData()
        }
    }
    
    @objc func tagRemoveButtonPressed(_ sender: RemoveButton){
        viewModel.removeTag(sender.title)
    }
    
    @objc func textFieldDidChange() {
        if tagTextField.text != "" && tagTextField.text!.count <= 10{
            tagList = oriTagList.filter({
                $0.name.contains(tagTextField.text!)
            })
            tagList.insert(TagModel(dictionary: ["name": tagTextField.text! + " 등록하기", "count": 0] ), at: 0)
        } else if tagTextField.text!.count > 10{
            let title = tagTextField.text ?? ""
            viewModel.title = title
            viewModel.alertControl()
            let index = title.index(title.startIndex, offsetBy: 9)
            tagTextField.text = String(title[...index])
        } else {
            reloadTagList()
        }
        reloadTable()
    }
    
    func reloadTagList() {
        tagList = oriTagList.filter({
            !tagData.contains($0.name)
        })
        tagList = tagList.sorted(by: { $0.count > $1.count})
        reloadTable()
    }
    
   
    func reloadTagStack() {
        tagTextField.text = ""
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        tagData.forEach {
            let tag = TagItem($0, button: true)
            
            tag.tagButton.title = $0
            tag.tagButton.addTarget(self, action: #selector(tagRemoveButtonPressed(_:)), for: .touchUpInside)
            
            contentView.addArrangedSubview(tag)
        }
        tagScrollView.scroll(to: .right)
        
        reloadTagList()
        reloadTable()
    }
    
    func alertAction() {
        presentOkOnlyAlert(title: alertModel.title ?? "", message: alertModel.message, handler: nil)
    }
}

extension TagVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tagListTableView.dequeueReusableCell(withIdentifier: "TagListTableViewCell") as! TagListTableViewCell
        let count = tagList[indexPath.row].count
        
        cell.tagLabel.text = tagList[indexPath.row].name
        if count > 10 {
            cell.countLabel.isHidden = false
            cell.countLabel.text = String(count)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var title = tagList[indexPath.row].name
   
        if title.contains(" 등록하기") {
            let tag = title.index(title.endIndex, offsetBy: -5)
            title = String(title[...tag])
        }
        
        title = title.filter{ !" ".contains($0) }
        viewModel.title = title
        viewModel.alertControl()
    }
}

extension TagVC {
    func configureUI() {
        layout()
        setting()
        binding()
    }
    
    func binding() {
        viewModel.tagList.bind { [weak self] data in
            self?.tagList = data
            self?.oriTagList = data
            self?.reloadTable()
        }
        viewModel.tagData.bind { [weak self] data in
            self?.tagData = data
            self?.reloadTagStack()
        }
        viewModel.alert.bind { [weak self] data in
            self?.alertModel = data
            self?.alertAction()
        }
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

