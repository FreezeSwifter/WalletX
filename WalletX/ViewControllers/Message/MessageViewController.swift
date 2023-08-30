//
//  MessageViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import NSObject_Rx

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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.rx.notification(.languageChanged).observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            self?.tabBarItem.title = "tab_message".toMultilingualism()
            self?.headerView?.titleLabel.text = "message_noti".toMultilingualism()
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
        bind()
    }
    
    private func bind() {
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            let settingVC: SettingViewController = ViewLoader.Xib.controller()
            settingVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(settingVC, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
        headerView?.scanButton.rx.tap.subscribe(onNext: {[weak self] in
            let sancVC: ScanViewController = ViewLoader.Xib.controller()
            sancVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(sancVC, animated: true)
        }).disposed(by: rx.disposeBag)
        
        headerView?.shareButton.rx.tap.subscribe(onNext: {[weak self] in
            let shareVC: ShareViewController = ViewLoader.Xib.controller()
            shareVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(shareVC, animated: true)
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
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
        
        let vc: MessageDetailViewController = MessageDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
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
