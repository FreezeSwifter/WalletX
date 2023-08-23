//
//  GuranteeViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit
import SnapKit
import IGListKit
import LocalAuthentication
import MMKV
import RxCocoa
import RxSwift
import NSObject_Rx

class GuranteeViewController: UIViewController, HomeNavigationble {

    private var adapter: ListAdapter!
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.rx.notification(.languageChanged).observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            self?.tabBarItem.title = "tab_guaranties".toMultilingualism()
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupView()
        bind()
    }
    
    private func setupView() {
        
        setupNavigationbar()
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 3)
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        collectionView.backgroundColor = UIColor.white
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView!.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
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
}

extension GuranteeViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [HomeBannerSection.Model(), HomeQuickAccessSecion.Model(), HomeServiceProviderSecion.Model()]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object  {
            
        case is HomeBannerSection.Model:
            return HomeBannerSection()
            
        case is HomeQuickAccessSecion.Model:
            return HomeQuickAccessSecion()
            
        case is HomeServiceProviderSecion.Model:
            return HomeServiceProviderSecion()
            
        default:
            return ListSectionController()
        }
        
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
      return nil
    }
}
