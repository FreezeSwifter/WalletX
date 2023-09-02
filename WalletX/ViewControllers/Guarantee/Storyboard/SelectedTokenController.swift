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
    
    enum OperationType {
        case send
        case receive
    }
    
    var operationType: OperationType = .send
    private var datasource: [WalletToken] = []
    
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
        if !LocaleWalletManager.shared().hasWallet { return }
        if let usdt = LocaleWalletManager.shared().USDT {
            datasource.append(usdt)
        }
        if let tron = LocaleWalletManager.shared().TRON {
            datasource.append(tron)
        }
        tableView.reloadData()
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
        
        let item = datasource[indexPath.row]
        switch operationType {
        case .send:
            let vc: SendTokenPageOneController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.model = item
            navigationController?.pushViewController(vc, animated: true)
        case .receive:
            let vc: ReceiveTokenController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.model = item
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SelectedTokenController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTokenCell", for: indexPath) as? WalletTokenCell
        
        let item = datasource[indexPath.row]
        cell?.iconImageView.image = item.iconImage
        cell?.tokenLabel.text = item.tokenName
        Task {
            let json = try? await LocaleWalletManager.shared().getAccount(walletToken: .tron(LocaleWalletManager.shared().TRON?.address))
            let tokenBalance = json?["balance"] as? Int64
            let formattedBalance = Double(tokenBalance ?? 0)
            switch item {
            case .tron:
                cell?.countLabel.text = String(format: "%.2f", formattedBalance)
            case .usdt:
                cell?.countLabel.text = "0"
            }
        }
        cell?.priceLabel.text = nil
        cell?.countPriceLabel.text = nil
        return cell ?? UITableViewCell()
    }
}
