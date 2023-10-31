//
//  MessageListCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 16.8.23.
//

import UIKit
import QMUIKit

class MessageListCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    
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
