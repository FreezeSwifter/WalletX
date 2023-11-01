//
//  MeListChildViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 17.8.23.
//

import UIKit
import JXSegmentedView
import RxCocoa
import RxSwift
import NSObject_Rx
import MJRefresh

protocol MeListChildViewDelegate: AnyObject {
    
    func listDidScroll(contentOffsetY: CGFloat)
}

class MeListChildViewController: UIViewController, JXSegmentedListContainerViewListDelegate {
    
    weak var delegate: MeListChildViewDelegate?
    
    var index: Int = 0
    private var pageNum: Int = 1
    private var datasource: [GuaranteeInfoModel.Meta] = []
    
    private lazy var tableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .plain)
        tv.estimatedRowHeight = 220
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.register(UINib(nibName: "MeTobeAddedCell", bundle: nil), forCellReuseIdentifier: "MeTobeAddedCell")
        tv.register(UINib(nibName: "GuaranteeingCell", bundle: nil), forCellReuseIdentifier: "GuaranteeingCell")
        return tv
    }()
    
    private let listEmptyView: MeListEmptyView = MeListEmptyView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        tableView.rx.contentOffset.subscribe(onNext: {[weak self] point in
            self?.delegate?.listDidScroll(contentOffsetY: point.y)
        }).disposed(by: rx.disposeBag)
        
        let header = MJRefreshGifHeader {[weak self] in
            self?.pageNum = 1
            self?.fetchData()
        }
        header.lastUpdatedTimeLabel?.isHidden = true
        header.setTitle("".toMultilingualism(), for: .idle)
        header.setTitle("加载中…".toMultilingualism(), for: .pulling)
        tableView.mj_header = header
        tableView.mj_header?.beginRefreshing()
        
        let footer = MJRefreshAutoGifFooter {[weak self] in
            self?.pageNum += 1
            self?.fetchData()
        }
        footer.setTitle("没有更多".toMultilingualism(), for: .noMoreData)
        footer.setTitle("".toMultilingualism(), for: .idle)
        footer.setTitle("加载中…".toMultilingualism(), for: .pulling)
        tableView.mj_footer = footer
        
        LocaleWalletManager.shared().walletDidChanged
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
            self?.fetchData()
        }).disposed(by: rx.disposeBag)
        
        NotificationCenter.default.rx.notification(.orderDidChangeed).observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.fetchData()
        }).disposed(by: rx.disposeBag)
    }
    
    @objc
    private func fetchData() {
        
        let parameter: Int? = (index == -1) ? nil : index
        let req: Observable<[GuaranteeInfoModel.Meta]> = APIProvider.rx.request(.queryAssureOrderList(assureStatus: parameter, pageNum: pageNum)).mapModelArray()
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
    
    private func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.trailing.leading.bottom.equalToSuperview()
        }
        
        listEmptyView.frame = tableView.frame
    }
    
    func listView() -> UIView {
        return view
    }
    
}

extension MeListChildViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let deleteAction = UIContextualAction(style: .normal, title: "删除".toMultilingualism()) { [weak self] (action, view, resultClosure) in
            guard let this = self, let id = this.datasource[indexPath.row].assureId else {
                return
            }
            APIProvider.rx.request(.deleteGuarantee(assureId: id)).mapJSON().subscribe().disposed(by: this.rx.disposeBag)
            this.datasource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
       
        deleteAction.backgroundColor = UIColor(hex: "#FF5966")
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        actions.performsFirstActionWithFullSwipe = false;
        return actions
    }
}

extension MeListChildViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if datasource.count == 0 {
            let header = tableView.mj_header as? MJRefreshGifHeader
            header?.lastUpdatedTimeLabel?.isHidden = true
            header?.stateLabel?.isHidden = true
            let footer = tableView.mj_footer as? MJRefreshAutoGifFooter
            footer?.stateLabel?.isHidden = true
            tableView.backgroundView = listEmptyView
        } else {
            let header = tableView.mj_header as? MJRefreshGifHeader
            header?.lastUpdatedTimeLabel?.isHidden = false
            header?.stateLabel?.isHidden = false
            let footer = tableView.mj_footer as? MJRefreshAutoGifFooter
            footer?.stateLabel?.isHidden = false
            tableView.backgroundView = nil
        }
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = datasource[indexPath.row]
        
        return configureAllCell(data: item, path: indexPath)
    }
}

private
extension MeListChildViewController {
    
    func configureAllCell(data: GuaranteeInfoModel.Meta, path: IndexPath) -> UITableViewCell {
        switch data.assureStatus {
        case 0, 1, 5, 7, 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeTobeAddedCell", for: path)
            as! MeTobeAddedCell
            cell.setupData(data: data)
            return cell
            
        case 2, 9, 3, 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuaranteeingCell", for: path) as! GuaranteeingCell
            cell.setupData(data: data)
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
}

