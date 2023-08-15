//
//  WalletSignatureViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 15.8.23.
//

import UIKit
import SnapKit
import JXSegmentedView

class WalletSignatureViewController: UIViewController, JXSegmentedListContainerViewListDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    func listView() -> UIView {
        return view
    }
}
