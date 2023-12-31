//
//  MessageDetailCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 30.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx
import WalletCore

class MessageDetailCell: UITableViewCell {
    
    var id: String?
    
    @IBOutlet weak var timeLabel: QMUILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.clipsToBounds = true
            avatarImageView.layer.cornerRadius = 25
            avatarImageView.backgroundColor = .darkGray
        }
    }
    
    @IBOutlet weak var contentLabel: QMUILabel! {
        didSet {
            contentLabel.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            contentLabel.backgroundColor = .white
            contentLabel.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var operationButton: UIButton! {
        didSet {
            operationButton.setupAPPUISolidStyle(title: "同意仲裁".toMultilingualism())
            operationButton.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

    }
    
    @IBAction func operationTap(_ sender: UIButton) {
        
        let assureId = id ?? ""
        let key = LocaleWalletManager.shared().currentWallet?.getKeyForCoin(coin: .tron).data.hexString ?? ""

        GuaranteeYesNoView.showFromCenter(image: UIImage(named: "guarantee_yes_no"), title: "您同意这个仲裁方法吗".toMultilingualism(), titleIcon: UIImage(named: "guarantee_bulb"), content: "仲裁弹窗内容".toMultilingualism(), leftButton: "取消".toMultilingualism(), rightButton: "确定".toMultilingualism()).subscribe(onNext: {[unowned self] index in
        
            if index == 1 {
                APIProvider.rx.request(.arbitrateAccept(assureId: assureId, key: key)).mapJSON().subscribe(onSuccess: { obj in
                    
                    guard let dict = obj as? [String: Any], let code = dict["code"] as? Int else { return }
                    if code != 0 {
                        APPHUD.flash(text: dict["message"] as? String)
                    } else {
                        APPHUD.flash(text: "成功".toMultilingualism())
                    }
                }).disposed(by: self.rx.disposeBag)
            }
            
        }).disposed(by: rx.disposeBag)
        
    }
}
