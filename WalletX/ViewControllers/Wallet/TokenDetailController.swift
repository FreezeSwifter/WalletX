//
//  TokenDetailController.swift
//  WalletX
//
//  Created by DZSB-001968 on 31.8.23.
//

import UIKit
import SnapKit
import JXSegmentedView
import RxCocoa
import RxSwift
import NSObject_Rx

class TokenDetailController: UIViewController, HomeNavigationble {
    
    var item: WalletToken?
    
    private let topOperatedView: WalletHeaderView = ViewLoader.Xib.view()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.rowHeight = 86
        tv.register(UINib(nibName: "TokenDetailCell", bundle: nil), forCellReuseIdentifier: "TokenDetailCell")
        tv.separatorStyle = .none
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
        Task {
            guard item != nil else { return }
            let formattedBalance = try? await LocaleWalletManager.shared().getTRONBalance()
            topOperatedView.topButton2.setTitle("TRX \(String(format: "%.2f", formattedBalance ?? 0.00))", for: .normal)
        }
        
        topOperatedView.receiveButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc: ReceiveTokenController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.model = self?.item
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
        topOperatedView.sendButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc: SendTokenPageOneController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.model = self?.item
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        setupNavigationbar()
        setupChildVCStyle()
        view.backgroundColor = ColorConfiguration.listBg.toColor()
        headerView?.titleLabel.text = item?.tokenName
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        view.addSubview(topOperatedView)
        topOperatedView.snp.makeConstraints { make in
            make.top.equalTo(headerView!.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(42)
            make.height.equalTo(220)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topOperatedView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        topOperatedView.topButton1.setImage(item?.iconImage, for: .normal)
        topOperatedView.topButton2.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        topOperatedView.topButton2.setTitleColor(ColorConfiguration.blodText.toColor(), for: .normal)
    }
}

extension TokenDetailController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc: TokenTransferDetailController = ViewLoader.Storyboard.controller(from: "Wallet")
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TokenDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TokenDetailCell", for: indexPath) as? TokenDetailCell
        
        return cell ?? UITableViewCell()
    }
}
