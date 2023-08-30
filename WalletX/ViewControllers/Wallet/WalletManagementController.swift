//
//  WalletManagementController.swift
//  WalletX
//
//  Created by DZSB-001968 on 30.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx

class WalletManagementController: UIViewController, HomeNavigationble {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .plain)
        tv.register(UINib(nibName: "WalletManagementCell", bundle: nil), forCellReuseIdentifier: "WalletManagementCell")
        tv.rowHeight = 80
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "钱包管理".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView!.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        headerView?.stackView.addArrangedSubview(headerView!.linkButton)
        headerView?.linkButton.setImage(UIImage(named: "wallet_add_new"), for: .normal)
        headerView?.linkButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc: ChangeNameController = ViewLoader.Storyboard.controller(from: "Wallet")
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        
    }
}


extension WalletManagementController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletManagementCell", for: indexPath) as? WalletManagementCell
        
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "删除".toMultilingualism()) { [weak self] (action, view, resultClosure) in
            guard self != nil else {
                return
            }
            
        }
        deleteAction.backgroundColor = UIColor(hex: "#FF5966")
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
}

