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
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var dataSource: [ListDiffable] = [HomeBannerSection.Model(), HomeQuickAccessSecion.Model(), HomeServiceProviderSecion.Model()]
    
    private let timer: Observable<Int> = Observable.timer(.seconds(1), period: .seconds(60), scheduler: MainScheduler.instance)
    
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
        headerView?.accountButton.rx.tap.subscribe(onNext: { _ in
            let vc: WalletManagementController = WalletManagementController()
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
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
        
        let bannerReq: Observable<[BannerModel]> = APIProvider.rx.request(.banner(type: 0)).mapModelArray()
        let totalCountReq = APIProvider.rx.request(.guaranteeDisplayData).mapJSON()
        let cartgoryListReq: Observable<[CategoryModel]> = APIProvider.rx.request(.serviceCategory).mapModelArray()
        
        bannerReq.subscribe {[weak self] list in
            let data = HomeBannerSection.Model()
            data.list = list
            self?.dataSource[0] = data
            self?.adapter.performUpdates(animated: true)
        }.disposed(by: rx.disposeBag)
        
        totalCountReq.subscribe(onSuccess: {[weak self] obj in
            let json = obj as? [String: Any]
            let data = json?["data"] as? [String: Any]
            let model = HomeQuickAccessSecion.Model()
            model.assureAmount = data?["assureAmount"] as? Int64
            model.assureNum = data?["assureNum"] as? Int64
            self?.dataSource[1] = model
            self?.adapter.performUpdates(animated: true)
        }).disposed(by: rx.disposeBag)
        
        cartgoryListReq.subscribe(onNext: {[weak self] list in
            let model = HomeServiceProviderSecion.Model()
            model.list = list
            self?.dataSource[2] = model
            self?.adapter.performUpdates(animated: true)
        }).disposed(by: rx.disposeBag)
        
        timer.subscribe(onNext: {[unowned self] i in
            refreshTotalCountData()
        }).disposed(by: rx.disposeBag)
    }
    
    private func refreshTotalCountData() {
        let totalCountReq = APIProvider.rx.request(.guaranteeDisplayData).mapJSON()
        totalCountReq.subscribe(onSuccess: {[weak self] obj in
            let json = obj as? [String: Any]
            let data = json?["data"] as? [String: Any]
            let model = HomeQuickAccessSecion.Model()
            model.assureAmount = data?["assureAmount"] as? Int64
            model.assureNum = data?["assureNum"] as? Int64
            self?.dataSource[1] = model
            self?.adapter.performUpdates(animated: true)
        }).disposed(by: rx.disposeBag)
    }
}

extension GuranteeViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource
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
