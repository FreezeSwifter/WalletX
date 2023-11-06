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
        
        operationButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let this = self else { return}
            APIProvider.rx.request(.arbitrateAccept(assureId: assureId, key: key)).mapJSON().subscribe(onSuccess: { obj in
                
                guard let dict = obj as? [String: Any], let code = dict["code"] as? Int else { return }
                if code != 0 {
                    APPHUD.flash(text: dict["message"] as? String)
                } else {
                    APPHUD.flash(text: "成功".toMultilingualism())
                }
                
            }).disposed(by: this.rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
    }
}
