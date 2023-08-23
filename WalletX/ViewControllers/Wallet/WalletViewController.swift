//
//  WalletViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit
import SnapKit
import JXSegmentedView
import RxCocoa
import RxSwift
import NSObject_Rx

class WalletViewController: UIViewController, HomeNavigationble {

    private let topOperatedView: WalletHeaderView = ViewLoader.Xib.view()
    private let titleData: [String] = ["wallet_tokens".toMultilingualism(), "wallet_signature".toMultilingualism()]
    
    private lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let ds = JXSegmentedTitleDataSource()
        ds.isTitleColorGradientEnabled = true
        ds.titleNormalColor = ColorConfiguration.descriptionText.toColor()
        ds.titleSelectedColor = ColorConfiguration.blackText.toColor()
        ds.itemSpacing = 20
        ds.isItemSpacingAverageEnabled = false
        ds.titleNormalFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        ds.isTitleZoomEnabled = false
        ds.titleSelectedZoomScale = 1
        ds.titles = titleData
        return ds
    }()
    
    private let segmentedView = JXSegmentedView()
    
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        let segContainerView = JXSegmentedListContainerView(dataSource: self, type: .scrollView)
        return segContainerView
    }()
    
    private lazy var childVC: [JXSegmentedListContainerViewListDelegate] = [WalletTokenViewController(), WalletSignatureViewController()]
    
    private let noWalletView: WalletWithoutWalletView = ViewLoader.Xib.view()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.rx.notification(.languageChanged).observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            self?.tabBarItem.title = "tab_wallet".toMultilingualism()
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.backgroundColor = ColorConfiguration.homeItemBg.toColor()
        setupNavigationbar()
        view.addSubview(topOperatedView)
        topOperatedView.snp.makeConstraints { make in
            make.top.equalTo(headerView!.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(42)
            make.height.equalTo(220)
        }
    
        topOperatedView.topButton1.setTitle("$0.00", for: UIControl.State())
        topOperatedView.topButton1.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        topOperatedView.topButton1.titleLabel?.minimumScaleFactor = 0.8
        topOperatedView.topButton1.setTitleColor(ColorConfiguration.blodText.toColor(), for: UIControl.State())
        
        topOperatedView.topButton2.setTitle("Wallet Address  ", for: UIControl.State())
        topOperatedView.topButton2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        topOperatedView.topButton2.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: UIControl.State())
        topOperatedView.topButton2.setImage(UIImage(named: "wallet_down_arrow"), for: UIControl.State())
        topOperatedView.topButton2.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        topOperatedView.topButton2.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        topOperatedView.topButton2.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        view.addSubview(segmentedView)
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = ColorConfiguration.blackText.toColor()
        segmentedView.indicators = [indicator]
        
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(topOperatedView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        listContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
        }
        segmentedView.backgroundColor = .white
        
        // 判断是否需要展示
        view.addSubview(noWalletView)
        noWalletView.snp.makeConstraints { make in
            make.top.equalTo(headerView!.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.4, delay: 5) {
            self.noWalletView.alpha = 0
        }
       
    }

}


extension WalletViewController: JXSegmentedListContainerViewDataSource {
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        
        return segmentedDataSource.titles.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        return childVC[index]
    }
}


extension WalletViewController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {

    }
}
