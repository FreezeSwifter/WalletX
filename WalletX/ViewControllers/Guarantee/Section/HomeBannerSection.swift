//
//  HomeBannerSection.swift
//  WalletX
//
//  Created by DZSB-001968 on 12.8.23.
//

import Foundation
import IGListKit
import IGListDiffKit

extension HomeBannerSection {
    
    class Model: NSObject, ListDiffable {
        
        var list: [BannerModel] = []
        
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


final class HomeBannerSection: ListSectionController {
    
    var data: Model?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        
        return CGSize(width: collectionContext!.containerSize.width, height: 170)
        
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        let cell = collectionContext?.dequeueReusableCell(of: HomeBannerSectionCellCollectionViewCell.self, for: self, at: index) as? HomeBannerSectionCellCollectionViewCell
        
        cell?.list = data?.list ?? []
        return cell ?? UICollectionViewCell()
    }
    
    override func didUpdate(to object: Any) {
        
        self.data = object as? Model
    }
}
