//
//  HomeQuickAccessSecion.swift
//  WalletX
//
//  Created by DZSB-001968 on 14.8.23.
//

import Foundation
import IGListKit
import IGListDiffKit
import RxCocoa
import NSObject_Rx

extension HomeQuickAccessSecion {
    
    class Model: NSObject, ListDiffable {
        
        var assureAmount: Int64?
        var assureNum: Int64?
        
        func diffIdentifier() -> NSObjectProtocol {
            return self
        }
        
        func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
            if let obj = object as? Model {
                return obj.assureNum == assureNum && obj.assureAmount == assureAmount
            }
            return false
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
        
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "HomeQuickAccessCell", bundle: nil, for: self, at: index) as? HomeQuickAccessCell else {
            return UICollectionViewCell()
        }
        cell.guranteeValueLabel.text = "\(data?.assureNum ?? 0)"
        cell.marginValueLabel.text = "\(data?.assureAmount ?? 0)"
        
        cell.joinBgView.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] in
            
            if !LocaleWalletManager.shared().hasWallet {
                self?.checkHasWalletPopAlter()
                return
            }
            
            let vc: JoinGuaranteeController = ViewLoader.Storyboard.controller(from: "Guarantee")
            vc.hidesBottomBarWhenPushed = true
            self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: cell.rx.disposeBag)
        
        cell.sendBgView.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] in
            
            if !LocaleWalletManager.shared().hasWallet {
                self?.checkHasWalletPopAlter()
                return
            }
            
            let vc: StartGuaranteeController = ViewLoader.Storyboard.controller(from: "Guarantee")
            vc.hidesBottomBarWhenPushed = true
            self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: cell.rx.disposeBag)
        
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.data = object as? Model
    }
    
    
    func checkHasWalletPopAlter() {
        
        GuaranteeYesNoView.showFromBottom(image: UIImage(named: "guarantee_yes_no"), title: "home_create_wallet_noti_title".toMultilingualism(), titleIcon: UIImage(named: "guarantee_bulb"), content: "home_create_wallet_noti_content".toMultilingualism(), leftButton: "home_after_button".toMultilingualism(), rightButton: "home_gonow_button".toMultilingualism()).subscribe(onNext: { index in
            
            if index == 1 {
                let app = UIApplication.shared.delegate as? AppDelegate
                app?.tabBarSelecte(index: 1)
            }
            
        }).disposed(by: rx.disposeBag)
    }
}
