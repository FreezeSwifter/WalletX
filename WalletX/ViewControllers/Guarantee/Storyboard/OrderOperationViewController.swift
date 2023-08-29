//
//  OrderOperationViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 29.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx

class OrderOperationViewController: UIViewController, HomeNavigationble {

    var state: OrderOperationGuarantee = .applyRelease {
        didSet {
            headerView?.titleLabel.text = state.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }
    
    private func bind() {
        
    }

    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = state.title
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }
}
