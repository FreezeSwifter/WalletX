//
//  MessageListCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 16.8.23.
//

import UIKit
import QMUIKit

class MessageListCell: UITableViewCell {

    @IBOutlet weak var dotLabel: QMUILabel! {
        didSet {
            dotLabel.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
            dotLabel.applyCornerRadius(dotLabel.height / 2)
            dotLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var topTitleLabel: UILabel! {
        didSet {
            topTitleLabel.text = "--"
        }
    }

    @IBOutlet weak var bottomContentLabel: UILabel! {
        didSet {
            bottomContentLabel.text = "--"
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.text = "--"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
