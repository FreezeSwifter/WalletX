//
//  SelectedTokenController.swift
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


class SelectedTokenController: UIViewController, HomeNavigationble {

    @IBOutlet weak var searchBg: UIView! {
        didSet {
            searchBg.applyCornerRadius(20)
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.placeholder = "搜索币种".toMultilingualism()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = .white
            tableView.register(UINib(nibName: "WalletTokenCell", bundle: nil), forCellReuseIdentifier: "WalletTokenCell")
            tableView.separatorStyle = .none
            tableView.rowHeight = 90
        }
    }
    
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
        headerView?.titleLabel.text = "选择币种".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
    }
}

extension SelectedTokenController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
}

extension SelectedTokenController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTokenCell", for: indexPath) as? WalletTokenCell
        
        return cell ?? UITableViewCell()
    }
}
