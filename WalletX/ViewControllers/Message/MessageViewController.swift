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
import QMUIKit
import SwiftDate

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
    
    private var datasource: [MessageListModel] = []
    
    private let listEmptyView: MeListEmptyView = MeListEmptyView(frame: .zero)
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let app = UIApplication.shared.delegate as? AppDelegate
        app?.fetchMessage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
        bind()
        
    }
    
    private func bind() {
        
        fetchData()
        
        headerView?.accountButton.rx.tap.subscribe(onNext: { _ in
            LocaleWalletManager.checkLogin {
                let vc: WalletManagementController = WalletManagementController()
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: rx.disposeBag)
        
        headerView?.shareButton.rx.tap.subscribe(onNext: {[weak self] in
            let shareVC: ShareViewController = ViewLoader.Xib.controller()
            shareVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(shareVC, animated: true)
        }).disposed(by: rx.disposeBag)
        
        headerView?.serverButton.rx.tap.subscribe(onNext: { _ in
            let app = UIApplication.shared.delegate as? AppDelegate
            app?.openTg()
        }).disposed(by: rx.disposeBag)
        
        NotificationCenter.default.rx.notification(.languageChanged).observe(on: MainScheduler.instance).subscribe(onNext: { _ in
            let app = UIApplication.shared.delegate as? AppDelegate
            app?.fetchMessage()
        }).disposed(by: rx.disposeBag)
    }
    
    private func fetchData() {
        let app = UIApplication.shared.delegate as? AppDelegate
        app?.messageData.subscribe(onNext: { [weak self] list in
            self?.datasource = list ?? []
            if self?.datasource.count == 0 {
                self?.tableView.backgroundView = self?.listEmptyView
            } else {
                self?.tableView.backgroundView = nil
            }
            self?.tableView.reloadData()
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
        
        listEmptyView.frame = tableView.frame
        listEmptyView.label.text = "暂无数据".toMultilingualism()
        listEmptyView.listEmptyImageView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
    }
}

extension MessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc: MessageDetailViewController = MessageDetailViewController()
        let item = datasource[indexPath.row]
        vc.item = item
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as! MessageListCell
        let item = datasource[indexPath.row]
        cell.topTitleLabel.text = item.displayType()
        cell.bottomContentLabel.text = item.content
        cell.timeLabel.text = Date(timeIntervalSince1970: Double((item.createTime ?? 0)) / 1000 ).toRelative(style: RelativeFormatter.twitterStyle())
        cell.icon.image = UIImage(named: item.displayIcon())
        if item.status == 0 {
            cell.icon.qmui_shouldShowUpdatesIndicator = true
            cell.icon.qmui_badgeInteger = 0
        } else {
            cell.icon.qmui_shouldShowUpdatesIndicator = false
            cell.icon.qmui_badgeInteger = 0
        }
        return cell
    }
}
