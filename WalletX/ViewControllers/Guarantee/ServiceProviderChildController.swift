//
//  ServiceProviderChildController.swift
//  WalletX
//
//  Created by DZSB-001968 on 21.8.23.
//

import UIKit
import JXSegmentedView
import SnapKit
import RxCocoa
import RxSwift
import NSObject_Rx

class ServiceProviderChildController: UIViewController, JXSegmentedListContainerViewListDelegate {
    
    var index: Int = 0 {
        didSet {
            bind()
        }
    }
    
    var category: CategoryModel?
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: view.bounds,
                                  collectionViewLayout: flowLayout)
        cv.register(UINib(nibName: "ServiceProviderChildCell", bundle: nil), forCellWithReuseIdentifier: "ServiceProviderChildCell")
        cv.register(UINib(nibName: "ServiceProviderHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ServiceProviderHeaderView")
        cv.applyCornerRadius(7)
        cv.delegate = self
        cv.dataSource = self
        
        cv.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return cv
    }()
    
    private var datasourceAll: [ServiceDetailModel] = []
    private var datasourceOther: [ServiceListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        
    }
    
    func listView() -> UIView {
        return view
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = ColorConfiguration.grayBg.toColor()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func bind() {
        if index == 0 {
            let req: Observable<[ServiceDetailModel]> = APIProvider.rx.request(.serviceList(categoryId: "0")).mapModelArray()
            req.subscribe(onNext: {[weak self] data in
                self?.datasourceAll = data
                self?.collectionView.reloadData()
            }).disposed(by: rx.disposeBag)
            
        } else {
            let id = category?.id ?? ""
            let req: Observable<[ServiceListModel]> = APIProvider.rx.request(.serviceList(categoryId: id)).mapModelArray()
            req.subscribe(onNext: {[weak self] data in
                self?.datasourceOther = data
                self?.collectionView.reloadData()
            }).disposed(by: rx.disposeBag)
        }
    }
}

extension ServiceProviderChildController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if index == 0 {
            return datasourceAll.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if index == 0 {
            return datasourceAll[section].merchantList?.count ?? 0
        } else {
            return datasourceOther.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceProviderChildCell", for: indexPath) as? ServiceProviderChildCell
        
        if index == 0 {
            let item = datasourceAll[indexPath.section].merchantList?[indexPath.item]
            cell?.label.text = item?.mertName
        } else {
            let item = datasourceOther[indexPath.item]
            cell?.label.text = item.mertName
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ServiceProviderHeaderView", for: indexPath) as! ServiceProviderHeaderView
            if index == 0 {
                let item = datasourceAll[indexPath.section]
                sectionHeader.label.text = item.category?.category
            }
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if index == 0 {
            return CGSize(width: view.bounds.width - 20, height: 50)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 3) - 40, height: 40)
    }
}
