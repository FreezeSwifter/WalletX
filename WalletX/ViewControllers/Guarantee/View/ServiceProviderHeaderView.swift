//
//  ServiceProviderHeaderView.swift
//  WalletX
//
//  Created by DZSB-001968 on 8.9.23.
//

import UIKit

class ServiceProviderHeaderView: UICollectionReusableView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var label: UILabel! {
        didSet {
            label.minimumScaleFactor = 0.5
            label.adjustsFontSizeToFitWidth = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
