//
//  StartGuaranteeController.swift
//  WalletX
//
//  Created by DZSB-001968 on 23.8.23.
//

import UIKit

class StartGuaranteeController: UIViewController, HomeNavigationble {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "home_newGuaranty".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    
    }

}
