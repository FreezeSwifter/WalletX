//
//  HomeQuickAccessSecion.swift
//  WalletX
//
//  Created by DZSB-001968 on 14.8.23.
//

import Foundation
import IGListKit
import IGListDiffKit

extension HomeQuickAccessSecion {
    
    class Model: NSObject, ListDiffable {
        
        func diffIdentifier() -> NSObjectProtocol {
            return self
        }
        
        func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
            return isEqual(object)
        }
    }
}


final class HomeQuickAccessSecion: ListSectionController {
    
    var data: Model?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
 
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        
        return CGSize(width: collectionContext!.containerSize.width, height: 224)

    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
     
        let cell = collectionContext?.dequeueReusableCell(withNibName: "HomeQuickAccessCell", bundle: nil, for: self, at: index) as? HomeQuickAccessCell
        return cell ?? UICollectionViewCell()
    }
    
    override func didUpdate(to object: Any) {
        self.data = object as? Model
    }
}
