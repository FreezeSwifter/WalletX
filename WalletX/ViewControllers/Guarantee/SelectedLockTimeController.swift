//
//  SelectedLockTimeController.swift
//  WalletX
//
//  Created by DZSB-001968 on 26.12.23.
//

import UIKit

class SelectedLockTimeController: UIViewController, HomeNavigationble {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = 46
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationbar()
        setupChildVCStyle()
        headerView?.backgroundColor = .white
        headerView?.titleLabel.text = "自动锁定".toMultilingualism()
    }

}

extension SelectedLockTimeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LockManager.shareInstance.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let model = LockManager.shareInstance.data[indexPath.row]
        cell.textLabel?.text = model.name
        if model.isSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LockManager.shareInstance.currentIndex = indexPath.row
        navigationController?.popViewController(animated: true)
    }
}
