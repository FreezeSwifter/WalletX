//
//  PendingPledgeListView.swift
//  WalletX
//
//  Created by DZSB-001968 on 24.9.23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx
import MJRefresh

class PendingPledgeListView: UIView {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.rowHeight = 60
        tv.register(UINib(nibName: "PendingPledgeListCell", bundle: nil), forCellReuseIdentifier: "PendingPledgeListCell")
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        return tv
    }()
    
    private var pageNum: Int = 1
    private var datasource: [GuaranteeInfoModel.Meta] = []
    private var didSelectedItem: ((GuaranteeInfoModel.Meta) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setupDidSelectedItem(block: ((GuaranteeInfoModel.Meta) -> Void)?) {
        didSelectedItem = block
    }
    
    private func commonInit() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let header = MJRefreshGifHeader {[weak self] in
            self?.pageNum = 1
            self?.fetchData()
        }
        header.lastUpdatedTimeLabel?.isHidden = true
        header.setTitle("加载中…".toMultilingualism(), for: .idle)
        header.setTitle("加载中…".toMultilingualism(), for: .pulling)
        tableView.mj_header = header
        tableView.mj_header?.beginRefreshing()
        
        let footer = MJRefreshAutoGifFooter {[weak self] in
            self?.pageNum += 1
            self?.fetchData()
        }
        footer.setTitle("没有更多".toMultilingualism(), for: .noMoreData)
        footer.setTitle("加载中…".toMultilingualism(), for: .idle)
        footer.setTitle("加载中…".toMultilingualism(), for: .pulling)
        tableView.mj_footer = footer
    }
    
    private func fetchData() {
        let req: Observable<[GuaranteeInfoModel.Meta]> = APIProvider.rx.request(.queryAssureOrderList(assureStatus: 1, pageNum: pageNum)).mapModelArray()
        req.subscribe(onNext: {[weak self] list in
        
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            if self?.pageNum == 1 {
                self?.tableView.mj_footer?.resetNoMoreData()
                self?.datasource.removeAll()
            }
            if list.count != 0 {
                self?.datasource.append(contentsOf: list)
            } else {
                self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self?.tableView.reloadData()
        }).disposed(by: rx.disposeBag)
    }
}

extension PendingPledgeListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingPledgeListCell", for: indexPath) as? PendingPledgeListCell
        let item = datasource[indexPath.row]
        let str = "\(item.assureId ?? ""), \(item.pushWaitAmount ?? 0.0)"
        cell?.mainTextLabel.text = str
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = datasource[indexPath.row]
        didSelectedItem?(item)
    }
}
