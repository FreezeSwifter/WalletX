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
    private var filterDatasrouce: [WalletToken] = []
    
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
        filterDatasrouce = datasource
        tableView.reloadData()
        
        textField.rx.text.orEmpty.changed.throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] str in
                if str.count == 0 {
                    self?.filterDatasrouce = self?.datasource ?? []
                } else {
                    let uppercased = str.uppercased()
                    self?.filterDatasrouce = self?.datasource.filter { $0.tokenName.contains(uppercased) } ?? []
                }
                self?.tableView.reloadData()
            }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "选择币种".toMultilingualism()
        headerView?.backgroundColor = .white
        
    }
}

extension SelectedTokenController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = filterDatasrouce[indexPath.row]
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
        return filterDatasrouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTokenCell", for: indexPath) as! WalletTokenCell
        
        let item = filterDatasrouce[indexPath.row]
        cell.iconImageView.image = item.iconImage
        cell.tokenLabel.text = item.tokenName
        cell.priceLabel.text = item.companyName
        
        let token = LocaleWalletManager.shared().walletBalance.share().map { m in
            switch item {
            case .usdt:
                return m?.data?.USDT
            case .tron:
                return m?.data?.TRX
            }
        }
        token.bind(to: cell.countLabel.rx.text).disposed(by: cell.rx.disposeBag)
        cell.countPriceLabel.text = nil
        return cell 
    }
}
