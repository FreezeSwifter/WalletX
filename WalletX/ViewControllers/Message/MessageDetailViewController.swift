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

class MessageDetailViewController: UIViewController, HomeNavigationble {
    
    var titleData: String? {
        didSet {
            headerView?.titleLabel.text = titleData
        }
    }
    
    private lazy var tableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .plain)
        tv.estimatedRowHeight = 200
        tv.register(UINib(nibName: "MessageDetailCell", bundle: nil), forCellReuseIdentifier: "MessageDetailCell")
        tv.backgroundColor = UIColor(hex: "#F5F8FE")
        tv.dataSource = self
        tv.separatorStyle = .none
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageDetailCell", for: indexPath) as? MessageDetailCell
        cell?.timeLabel.text = Date().description
        if indexPath.row == 0 {
            cell?.contentLabel.text = "刷卡机拉屎卡拉季哦忘记考拉手机打金娃i啊看收垃圾大了哇阿斯兰进度款拉数据打了可视角度考拉时间段立卡见识到了看见啊卢卡斯建档立卡阿斯卡来得及啦可视角度拉数据狄拉克久等啦看手机到啦可视角度啦可视对讲啦可视角度立卡见识到了卡加斯达克拉阿加莎电力科技阿卡丽受打击阿里可视对讲啦可视角度啦可视角度啦可视角度拉克丝较大来上课大家啊啦可视角度拉克丝较大拉卡萨较大"
        } else {
            cell?.contentLabel.text = "啦啦啦啦啦"
        }
        return cell ?? UITableViewCell()
    }
}
