//
//  MessageListCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 16.8.23.
//

import UIKit
import QMUIKit

class MessageListCell: UITableViewCell {

    @IBOutlet weak var numLabel: QMUILabel! {
        didSet {
            numLabel.contentEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
            numLabel.isHidden = true
            numLabel.backgroundColor = .red
            numLabel.clipsToBounds = true
        }
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        numLabel.layer.cornerRadius = 4
    }
    
}
