//
//  GuranteeViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit
import SnapKit
import IGListKit

class GuranteeViewController: UIViewController {

    private let headerView: HomeNavigationBarView = ViewLoader.Xib.view()
    private var adapter: ListAdapter!
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.fd_prefersNavigationBarHidden = true
        setupView()
        
    }
    
    private func setupView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(self.qmui_navigationBarMaxYInViewCoordinator)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 3)
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        collectionView.backgroundColor = UIColor.white
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
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
