//
//  ServiceProviderNotiView.swift
//  WalletX
//
//  Created by DZSB-001968 on 21.8.23.
//

import UIKit

class ServiceProviderNotiView: UIView {

    @IBOutlet weak var textLabel: UILabel! {
        didSet {
            textLabel.textColor = ColorConfiguration.originNotiText.toColor()
            textLabel.text = "home_noti_text".toMultilingualism()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = ColorConfiguration.originNotiBg.toColor()
    
    }
}
