//
//  TokenDetailCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 31.8.23.
//

import UIKit

class TokenDetailCell: UITableViewCell {

    @IBOutlet weak var transferLabel: UILabel! {
        didSet {
            transferLabel.text = "转账".toMultilingualism()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
