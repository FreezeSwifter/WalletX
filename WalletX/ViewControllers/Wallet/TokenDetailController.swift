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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {

       LocaleWalletManager.shared().walletBalance.share().map {[weak self] m in
            switch self?.item {
            case .usdt:
                return "\(m?.data?.USDT ?? "0") USDT"
            case .tron:
                return "\(m?.data?.TRX ?? "0") TRX"
            default:
                return "\(m?.data?.USDT ?? "0") USDT"
            }
       }.subscribe(onNext: {[weak self] token in
           
           self?.topOperatedView.topButton2.setTitle(token, for: .normal)
        
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
        let symbolID = item?.tokenName ?? "USDT"
        let req: Observable<[TokenTecordTransferModel]> = APIProvider.rx.request(.getTokenTecordTransfer(pageNumber: pageNum, symbolID: symbolID)).mapModelArray()
        
        req.subscribe(onNext: {[weak self] list in
            self?.datasource = list
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
        vc.item = item
        vc.model = datasource[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TokenDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TokenDetailCell", for: indexPath) as? TokenDetailCell
        let item = datasource[indexPath.row]
        cell?.setupData(data: item)
        return cell ?? UITableViewCell()
    }
}
