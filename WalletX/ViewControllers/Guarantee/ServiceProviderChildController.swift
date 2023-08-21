//
//  ServiceProviderChildController.swift
//  WalletX
//
//  Created by DZSB-001968 on 21.8.23.
//

import UIKit
import JXSegmentedView

class ServiceProviderChildController: UIViewController, JXSegmentedListContainerViewListDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorConfiguration.grayBg.toColor()
    }
    
    func listView() -> UIView {
        return view
    }
    
}
