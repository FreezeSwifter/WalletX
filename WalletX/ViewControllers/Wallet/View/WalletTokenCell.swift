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
    
    @IBOutlet weak var tokenLabel: UILabel! {
        didSet {
            tokenLabel.text = "--"
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.text = "--"
        }
    }
    
    @IBOutlet weak var countLabel: UILabel! {
        didSet {
            countLabel.text = "--"
        }
    }
    
    @IBOutlet weak var countPriceLabel: UILabel! {
        didSet {
            countPriceLabel.text = "--"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .white
        contentView.backgroundColor = .white
    }
}
