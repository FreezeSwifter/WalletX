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

extension HomeServiceProviderSecion {
    
    class Model: NSObject, ListDiffable {
        
        func diffIdentifier() -> NSObjectProtocol {
            return self
        }
        
        func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
            return isEqual(object)
        }
    }
}


final class HomeServiceProviderSecion: ListSectionController {
    
    var data: Model?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
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
        let provideVC = ServiceProviderController()
        provideVC.hidesBottomBarWhenPushed = true
        cell.moreButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.viewController?.navigationController?.pushViewController(provideVC, animated: true)
        }).disposed(by: cell.rx.disposeBag)
        
        cell.changeButton.rx.tap.subscribe(onNext: {[weak cell] _ in
            cell?.changeButton.isSelected = true
            cell?.collectButton.isSelected = false
            
        }).disposed(by: cell.rx.disposeBag)
        
        cell.collectButton.rx.tap.subscribe(onNext: {[weak cell] _ in
            cell?.changeButton.isSelected = false
            cell?.collectButton.isSelected = true
            
        }).disposed(by: cell.rx.disposeBag)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.data = object as? Model
    }
}
