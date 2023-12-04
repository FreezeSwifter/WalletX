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
    
    private var titleData: [String] {
        return  ["wallet_tokens".toMultilingualism()]
    }
    
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
    
    private lazy var childVC: [JXSegmentedListContainerViewListDelegate] = [WalletTokenViewController()]
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocaleWalletManager.shared().fetchWalletBalanceData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        
    }
    
    private func bind() {
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
        
        topOperatedView.sendButton.rx.tap.subscribe(onNext: { _ in
            let vc: SelectedTokenController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.operationType = .send
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
        topOperatedView.receiveButton.rx.tap.subscribe(onNext: { _ in
            let vc: SelectedTokenController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.operationType = .receive
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
        topOperatedView.walletButton.rx.tap.subscribe(onNext: { _ in
            let vc: DepositViewController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
        LanguageManager.shared().languageDidChanged.subscribe(onNext: {[weak self] _ in
            self?.segmentedDataSource.titles = self?.titleData ?? []
            self?.segmentedView.reloadData()
        }).disposed(by: rx.disposeBag)
        
        LocaleWalletManager.shared().walletDidChanged.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            guard let this = self else { return }
            if LocaleWalletManager.shared().hasWallet {
                this.view.sendSubviewToBack(this.noWalletView)
                this.noWalletView.alpha = 0
            } else {
                this.view.bringSubviewToFront(this.noWalletView)
                this.noWalletView.alpha = 1
            }
            
            this.updateBalance()
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    private func setupView() {
        view.backgroundColor = ColorConfiguration.homeItemBg.toColor()
        setupNavigationbar()
        
        view.addSubview(topOperatedView)
        topOperatedView.snp.makeConstraints { make in
            make.top.equalTo(headerView!.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(42)
            make.height.equalTo(176)
        }
        
        topOperatedView.topButton1.setTitle("$0.00", for: UIControl.State())
        topOperatedView.topButton1.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        topOperatedView.topButton1.titleLabel?.minimumScaleFactor = 0.5
        topOperatedView.topButton1.titleLabel?.adjustsFontSizeToFitWidth = true
        topOperatedView.topButton1.setTitleColor(ColorConfiguration.blodText.toColor(), for: UIControl.State())
        
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
        
        view.addSubview(noWalletView)
        noWalletView.snp.makeConstraints { make in
            make.top.equalTo(headerView!.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        if LocaleWalletManager.shared().hasWallet {
            view.sendSubviewToBack(noWalletView)
            noWalletView.alpha = 0
        } else {
            view.bringSubviewToFront(noWalletView)
            noWalletView.alpha = 1
        }
    }
    
    private func updateBalance() {
        
        LocaleWalletManager.shared().walletBalance.subscribe(onNext: {[weak self] obj in
            self?.topOperatedView.topButton1.setTitle("$\(obj?.data?.USDT ?? "")", for: .normal)
        }).disposed(by: rx.disposeBag)
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
