//
//  TokenDetailCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 31.8.23.
//

import UIKit
import SwiftDate

class TokenDetailCell: UITableViewCell {

    @IBOutlet weak var transferLabel: UILabel! {
        didSet {
            transferLabel.text = "转账".toMultilingualism()
        }
    }
    
    @IBOutlet weak var fromLabel: UILabel! {
        didSet {
            fromLabel.minimumScaleFactor = 0.5
            fromLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.minimumScaleFactor = 0.5
            timeLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(data: TokenTecordTransferModel) {
        fromLabel.text = data.from
        timeLabel.text = Date(timeIntervalSince1970: (data.createTime ?? 0) / 1000 ).toFormat("yyyy-MM-dd HH:mm:ss")
        if data.amount ?? 0 > 0 {
            countLabel.textColor = UIColor(hex: "#16C784")
        } else {
            countLabel.textColor = UIColor(hex: "#FF5966")
        }
        countLabel.text = "\(data.amount ?? 0)"
        
    }
}
