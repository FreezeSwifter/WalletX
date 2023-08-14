//
//  HomeNavigationBarView.swift
//  WalletX
//
//  Created by DZSB-001968 on 11.8.23.
//

import UIKit

class HomeNavigationBarView: UIView {

    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var ServerButton: UIButton!
    
    @IBOutlet weak var scanButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
