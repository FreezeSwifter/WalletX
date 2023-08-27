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

protocol MeListChildViewDelegate: AnyObject {
    
    func listDidScroll(contentOffsetY: CGFloat)
}

class MeListChildViewController: UIViewController, JXSegmentedListContainerViewListDelegate {
    
    weak var delegate: MeListChildViewDelegate?
    
    private lazy var tableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .plain)
        tv.rowHeight = 216
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
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
}

extension MeListChildViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if true {
        //            tableView.backgroundView = listEmptyView
        //        } else {
        //            tableView.backgroundView = nil
        //        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = indexPath.row.description
        cell.backgroundColor = UIColor.qmui_random()
        return cell
    }
}

