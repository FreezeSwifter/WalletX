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
        tv.backgroundColor = .clear
        tv.register(UINib(nibName: "WalletTokenCell", bundle: nil), forCellReuseIdentifier: "WalletTokenCell")
        tv.separatorStyle = .none
        return tv
    }()
    
    private var datasource: [WalletToken] = []
    
    private var isDeviceDisabled = false

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NotificationCenter.default.rx.notification(.deviceDisabled).observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            self?.isDeviceDisabled = true
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }

    func listView() -> UIView {
        return view
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        LocaleWalletManager.shared().walletDidChanged.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            self?.datasource.removeAll()
            if !LocaleWalletManager.shared().hasWallet { return }
            if let usdt = LocaleWalletManager.shared().USDT {
                self?.datasource.append(usdt)
            }
            if let tron = LocaleWalletManager.shared().TRON {
                self?.datasource.append(tron)
            }
            self?.tableView.reloadData()
        }).disposed(by: rx.disposeBag)
    }
}

extension WalletTokenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let vc = TokenDetailController()
        let item = datasource[indexPath.row]
        vc.item = item
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WalletTokenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTokenCell", for: indexPath) as! WalletTokenCell
        let item = datasource[indexPath.row]
        cell.iconImageView.image = item.iconImage
        cell.tokenLabel.text = item.tokenName
        cell.priceLabel.text = item.companyName
        
        if isDeviceDisabled {
            cell.countLabel.text = "0.00"
            
        } else {
            let token = LocaleWalletManager.shared().walletBalance.share().map { m in
                switch item {
                case .usdt:
                    return m?.data?.USDT?.decimalPlaces(decimal: 2) ?? "NaN"
                case .tron:
                    return m?.data?.TRX?.decimalPlaces(decimal: 2) ?? "NaN"
                }
            }
            token.bind(to: cell.countLabel.rx.text).disposed(by: cell.rx.disposeBag)
        }
        
        cell.countPriceLabel.text = nil
        return cell
    }
}
