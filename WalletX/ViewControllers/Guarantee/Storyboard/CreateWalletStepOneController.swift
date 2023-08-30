//
//  CreateWalletStepOneController.swift
//  WalletX
//
//  Created by DZSB-001968 on 30.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx

class CreateWalletStepOneController: UIViewController, HomeNavigationble {

    @IBOutlet weak var topTitleLabel: UILabel! {
        didSet {
            topTitleLabel.text = "创建钱包第一步的标题".toMultilingualism()
        }
    }
    
    @IBOutlet weak var subDesLabel: UILabel! {
        didSet {
            subDesLabel.text = "创建钱包第一步的子标题".toMultilingualism()
        }
    }
    
    @IBOutlet weak var selectedStack1: UIStackView! {
        didSet {
            selectedStack1.layer.cornerRadius = 3
            selectedStack1.layer.borderWidth = 1
            selectedStack1.layer.borderColor = ColorConfiguration.blackText.toColor().withAlphaComponent(0.3).cgColor
            selectedStack1.isLayoutMarginsRelativeArrangement = true
            selectedStack1.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        }
    }
    
    @IBOutlet weak var selectedStack2: UIStackView! {
        didSet {
            selectedStack2.layer.cornerRadius = 3
            selectedStack2.layer.borderWidth = 1
            selectedStack2.layer.borderColor = ColorConfiguration.blackText.toColor().withAlphaComponent(0.3).cgColor
            selectedStack2.isLayoutMarginsRelativeArrangement = true
            selectedStack2.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        }
    }
    
    @IBOutlet weak var selectedStack3: UIStackView! {
        didSet {
            selectedStack3.layer.cornerRadius = 3
            selectedStack3.layer.borderWidth = 1
            selectedStack3.layer.borderColor = ColorConfiguration.blackText.toColor().withAlphaComponent(0.3).cgColor
            selectedStack3.isLayoutMarginsRelativeArrangement = true
            selectedStack3.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        }
    }
    
    @IBOutlet weak var selectedImage1: UIImageView!
    
    @IBOutlet weak var selectedLabel1: UILabel! {
        didSet {
            selectedLabel1.text = "创建钱包第一步按钮1".toMultilingualism()
        }
    }
    
    @IBOutlet weak var selectedImage2: UIImageView!
    
    @IBOutlet weak var selectedLabel2: UILabel! {
        didSet {
            selectedLabel2.text = "创建钱包第一步按钮2".toMultilingualism()
        }
    }
    
    @IBOutlet weak var selectedImage3: UIImageView!
    
    @IBOutlet weak var selectedLabel3: UILabel! {
        didSet {
            selectedLabel3.text = "创建钱包第一步按钮3".toMultilingualism()
        }
    }
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setupAPPUISolidStyle(title: "继续".toMultilingualism())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }

    private func bind() {
        nextButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc: CreateWalletStepTwoController = ViewLoader.Storyboard.controller(from: "Wallet")
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "助记词".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    
    }
}
