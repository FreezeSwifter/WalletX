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
import MJRefresh

class TokenDetailController: UIViewController, HomeNavigationble {
    
    var item: WalletToken?
    
    private let topOperatedView: WalletHeaderView = ViewLoader.Xib.view()
    
    private let listEmptyView: MeListEmptyView = MeListEmptyView(frame: .zero).then { it in
        it.label.text = "没有数据".toMultilingualism()
    }
    
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
    
    private var pageNum: Int = 1
    
    private var datasource: [TokenTecordTransferModel] = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        listEmptyView.frame = tableView.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {

       LocaleWalletManager.shared().walletBalance.share().map {[weak self] m in
            switch self?.item {
            case .usdt:
                return "\(m?.data?.USDT?.separatorStyleNumber(decimal: 2) ?? "NaN") USDT"
            case .tron:
                return "\(m?.data?.TRX?.separatorStyleNumber(decimal: 2) ?? "NaN") TRX"
            default:
                return "\(m?.data?.USDT?.separatorStyleNumber(decimal: 2) ?? "NaN") USDT"
            }
       }.subscribe(onNext: {[weak self] token in
                      
           self?.topOperatedView.topButton1.setTitle(token, for: .normal)
        
       }).disposed(by: rx.disposeBag)
        
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
        
        topOperatedView.walletButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc: DepositViewController = ViewLoader.Storyboard.controller(from: "Wallet")
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
      
        let header = MJRefreshGifHeader {[weak self] in
            self?.pageNum = 1
            self?.fetchData(isHeaderRefresh: true)
        }
        header.lastUpdatedTimeLabel?.isHidden = true
        header.setTitle("".toMultilingualism(), for: .idle)
        header.setTitle("加载中…".toMultilingualism(), for: .pulling)
        tableView.mj_header = header
        tableView.mj_header?.beginRefreshing()
        
        let footer = MJRefreshAutoGifFooter {[weak self] in
            self?.pageNum += 1
            self?.fetchData(isHeaderRefresh: false)
        }
        footer.setTitle("".toMultilingualism(), for: .noMoreData)
        footer.setTitle("".toMultilingualism(), for: .idle)
        footer.setTitle("加载中…".toMultilingualism(), for: .pulling)
        tableView.mj_footer = footer
        
    }
    
    private func fetchData(isHeaderRefresh: Bool = false) {
        let symbolID = item?.tokenName ?? "USDT"
        let req: Observable<[TokenTecordTransferModel]> = APIProvider.rx.request(.getTokenTecordTransfer(pageNumber: pageNum, symbolID: symbolID)).mapModelArray()
        
        req.subscribe(onNext: {[weak self] list in
            
            if isHeaderRefresh {
                self?.tableView.mj_footer?.resetNoMoreData()
                self?.datasource.removeAll()
            }
            
            if list.count != 0 {
                self?.datasource.append(contentsOf: list)
            }
            self?.tableView.reloadData()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            if list.count == 0 {
                self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        } ,onError: {[weak self] error in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            APPHUD.showError(error: error)
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        setupNavigationbar()
        setupChildVCStyle()
        view.backgroundColor = ColorConfiguration.listBg.toColor()
        headerView?.titleLabel.text = "\(item?.tokenName ?? "")(\(item?.companyName ?? ""))"

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
        topOperatedView.topButton1.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        topOperatedView.topButton1.setTitleColor(ColorConfiguration.blodText.toColor(), for: .normal)
        
        if item == .tron(nil) {
            topOperatedView.bottomStack.arrangedSubviews[topOperatedView.bottomStack.arrangedSubviews.count - 1].removeFromSuperview()
        }
    }
}

extension TokenDetailController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc: TokenTransferDetailController = ViewLoader.Storyboard.controller(from: "Wallet")
        let selectedItem = datasource[indexPath.row]
        vc.model = selectedItem
        vc.item = item
        vc.isFrmoTransferListPage = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TokenDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if datasource.count == 0 {
            tableView.backgroundView = listEmptyView
        } else {
            tableView.backgroundView = nil
        }
        
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TokenDetailCell", for: indexPath) as? TokenDetailCell
        let item = datasource[indexPath.row]
        cell?.setupData(data: item)
        return cell ?? UITableViewCell()
    }
}
