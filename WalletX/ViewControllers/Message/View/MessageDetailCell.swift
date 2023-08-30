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

class MessageDetailCell: UITableViewCell {
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

}
