//
//  PendingPledgeListCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 24.9.23.
//

import UIKit

class PendingPledgeListCell: UITableViewCell {

    @IBOutlet weak var mainTextLabel: UILabel! {
        didSet {
            mainTextLabel.adjustsFontSizeToFitWidth = true
            mainTextLabel.minimumScaleFactor = 0.5
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
