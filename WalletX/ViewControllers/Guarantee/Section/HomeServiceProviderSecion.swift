//
//  HomeServiceProviderSecion.swift
//  WalletX
//
//  Created by DZSB-001968 on 14.8.23.
//

import Foundation
import IGListKit
import IGListDiffKit
import RxCocoa
import NSObject_Rx
import RxSwift

extension HomeServiceProviderSecion {
    
    class Model: NSObject, ListDiffable {
        
        var list: [CategoryModel] = []
        
        func diffIdentifier() -> NSObjectProtocol {
            return self
        }
        
        func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
            if let obj = object as? Model {
                let isEqual = obj.list.elementsEqual(list) { a, b in
                    return a == b
                }
                return isEqual
            }
            return false
        }
    }
}


final class HomeServiceProviderSecion: ListSectionController {
    
    var data: Model?
    
    var currentServiceList: [ServiceListModel] = []
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        fetchDefaultServiceList()
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        
        return CGSize(width: collectionContext!.containerSize.width, height: 320)
        
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "ServiceProviderCell", bundle: nil, for: self, at: index) as? ServiceProviderCell else {
            return UICollectionViewCell()
        }
        cell.datasource = currentServiceList
        
        cell.moreButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let provideVC = ServiceProviderController()
            provideVC.list = self?.data?.list ?? []
            provideVC.hidesBottomBarWhenPushed = true
            self?.viewController?.navigationController?.pushViewController(provideVC, animated: true)
        }).disposed(by: cell.rx.disposeBag)
        
        if data?.list.count ?? 0 >= 1 {
            cell.changeButton.setTitle(data?.list[0].category, for: .normal)
        }
        if data?.list.count ?? 0 >= 2 {
            cell.collectButton.setTitle(data?.list[1].category, for: .normal)
        }
        
        cell.changeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            cell.changeButton.isSelected = true
            cell.collectButton.isSelected = false
            self?.changeButtonTap()
        }).disposed(by: cell.rx.disposeBag)
        
        cell.collectButton.rx.tap.subscribe(onNext: {[weak self] _ in
            cell.changeButton.isSelected = false
            cell.collectButton.isSelected = true
            self?.collectButtonTap()
        }).disposed(by: cell.rx.disposeBag)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.data = object as? Model
    }
    
    private func changeButtonTap() {
        if data?.list.count ?? 0 >= 1 {
            let id = data?.list[0].id ?? ""
            let req = APIProvider.rx.request(.serviceList(categoryId: id)).mapModelArray() as Observable<[ServiceListModel]>
            
            req.subscribe(onNext: {[weak self] items in
                self?.currentServiceList = items
            }).disposed(by: rx.disposeBag)
        }
    }
    
    private func collectButtonTap() {
        if data?.list.count ?? 0 >= 2 {
            let id = data?.list[1].id ?? ""
            let req = APIProvider.rx.request(.serviceList(categoryId: id)).mapModelArray() as Observable<[ServiceListModel]>
            
            req.subscribe(onNext: {[weak self] items in
                self?.currentServiceList = items
            }).disposed(by: rx.disposeBag)
        }
    }
    
    private func fetchDefaultServiceList() {
        let req = APIProvider.rx.request(.serviceList(categoryId: "1")).mapModelArray() as Observable<[ServiceListModel]>
        req.subscribe(onNext: {[weak self] items in
            self?.currentServiceList = items
            guard let this = self else { return }
            this.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(this)
            })
            
        }).disposed(by: rx.disposeBag)
        
    }
}
