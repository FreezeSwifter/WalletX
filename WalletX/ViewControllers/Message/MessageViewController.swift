//
//  MessageViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit
import SnapKit

class MessageViewController: UIViewController, HomeNavigationble {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .plain)
        tv.register(UINib(nibName: "MessageListCell", bundle: nil), forCellReuseIdentifier: "MessageListCell")
        tv.rowHeight = 80
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
        
    }
    
    func setupView() {
        setupNavigationbar()
        headerView?.titleLabel.text = "message_noti".toMultilingualism()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView!.snp.bottom)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
}

extension MessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as? MessageListCell
        
        return cell ?? UITableViewCell()
    }
}
