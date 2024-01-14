//
//  ServiceProviderChildCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 8.9.23.
//

import UIKit

class ServiceProviderChildCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel! {
        didSet {
            label.minimumScaleFactor = 0.5
            label.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.applyCornerRadius(4)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
