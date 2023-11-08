//
//  MessageDetailViewController.swift
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
import SwiftDate

class MessageDetailViewController: UIViewController, HomeNavigationble {
    
    var item: MessageListModel?
    
    private lazy var tableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .plain)
        tv.estimatedRowHeight = 200
        tv.register(UINib(nibName: "MessageDetailCell", bundle: nil), forCellReuseIdentifier: "MessageDetailCell")
        tv.backgroundColor = UIColor(hex: "#F5F8FE")
        tv.dataSource = self
        tv.separatorStyle = .none
        return tv
    }()
    
    private var datasource: [MessageDetailModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        headerView?.titleLabel.text = item?.displayType()
        if let id = item?.type {
            let req: Observable<[MessageDetailModel]> = APIProvider.rx.request(.messageDetail(id: id)).mapModelArray()
            req.subscribe(onNext: {[weak self] list in
                self?.datasource = list
                self?.tableView.reloadData()
            }).disposed(by: rx.disposeBag)
        }
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(headerView!.snp.bottom).offset(1)
        }
        
    }
}

extension MessageDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageDetailCell", for: indexPath) as? MessageDetailCell
        cell?.avatarImageView.image = UIImage(named: item?.displayIcon() ?? "")
        let model = datasource[indexPath.row]
        cell?.timeLabel.text = Date(timeIntervalSince1970: Double((model.createTime ?? 0)) / 1000 ).toRelative(style: RelativeFormatter.twitterStyle())
        
        let originStr = model.content ?? ""
        let newStr = originStr.replacingOccurrences(of: "{{\("同意仲裁".toMultilingualism())}}", with: "同意仲裁".toMultilingualism())
        cell?.contentLabel.text = newStr
        let hasAgree = model.content?.contains("\("同意仲裁".toMultilingualism())") ?? true
        cell?.operationButton.isHidden = !hasAgree
        
        if hasAgree {
            if LanguageManager.shared().currentCode == .cn {
                let str = model.content ?? ""
                let indexStart = 4
                let indexEnd = 17
                let startIndex = str.index(str.startIndex, offsetBy: indexStart)
                let endIndex = str.index(str.startIndex, offsetBy: indexEnd)
                let subStr = str[startIndex...endIndex]
                cell?.id = subStr.description
                
            } else {
                let str = model.content ?? ""
                let indexStart = 15
                let indexEnd = 28
                let startIndex = str.index(str.startIndex, offsetBy: indexStart)
                let endIndex = str.index(str.startIndex, offsetBy: indexEnd)
                let subStr = str[startIndex...endIndex]
                cell?.id = subStr.description
            }
        }
        
        return cell ?? UITableViewCell()
    }
}
