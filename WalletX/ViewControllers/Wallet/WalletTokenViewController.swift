//
//  WalletTokenViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 15.8.23.
//

import UIKit
import JXSegmentedView
import RxCocoa
import RxSwift
import NSObject_Rx

class WalletTokenViewController: UIViewController, JXSegmentedListContainerViewListDelegate {

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.rowHeight = 90
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.register(UINib(nibName: "WalletTokenCell", bundle: nil), forCellReuseIdentifier: "WalletTokenCell")
        tv.separatorStyle = .none
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func listView() -> UIView {
        return view
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension WalletTokenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
}

extension WalletTokenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTokenCell", for: indexPath) as? WalletTokenCell
        
        return cell ?? UITableViewCell()
    }
}
