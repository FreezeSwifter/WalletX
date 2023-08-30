//
//  WalletTokenCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 30.8.23.
//

import UIKit

class WalletTokenCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.applyCornerRadius(18)
        }
    }
    
    @IBOutlet weak var tokenLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var countPriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
