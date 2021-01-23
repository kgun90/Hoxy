//
//  HomeVC.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/23.
//

import UIKit

class HomeVC: UIViewController {
    lazy var listTableView = UITableView().then {
        $0.backgroundColor = .mainBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
//        let cell = 
    }
    
    
}
