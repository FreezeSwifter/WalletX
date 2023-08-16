//
//  MeListChildViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 17.8.23.
//

import UIKit
import JXSegmentedView
import RxCocoa
import RxSwift
import NSObject_Rx

class MeListChildViewController: UIViewController, JXSegmentedListContainerViewListDelegate {

    private lazy var tableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .plain)
        tv.rowHeight = 216
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        return tv
    }()
        
    private let listEmptyView: MeListEmptyView = MeListEmptyView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.trailing.leading.bottom.equalToSuperview()
        }
        
        listEmptyView.frame = tableView.frame
    }
    
    func listView() -> UIView {
        return view
    }

}

extension MeListChildViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MeListChildViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if true {
            tableView.backgroundView = listEmptyView
        } else {
            tableView.backgroundView = nil
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        return UITableViewCell()
    }
}

