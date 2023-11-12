//
//  SendTokenPageTwoController.swift
//  WalletX
//
//  Created by DZSB-001968 on 31.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx

class SendTokenPageTwoController: UIViewController, HomeNavigationble {

    var model: WalletToken?
    var toAddress: String?
    var sendCount: String?
    
    @IBOutlet weak var topLabel: UILabel! {
        didSet {
            topLabel.text = "--"
        }
    }
    
    @IBOutlet weak var topSubLabel: UILabel! {
        didSet {
            topSubLabel.text = "--"
        }
    }
    
    @IBOutlet weak var desBg1: UIStackView! {
        didSet {
            desBg1.isLayoutMarginsRelativeArrangement = true
            desBg1.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    @IBOutlet weak var desBg2: UIStackView! {
        didSet {
            desBg2.isLayoutMarginsRelativeArrangement = true
            desBg2.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    @IBOutlet weak var desBg3: UIStackView! {
        didSet {
            desBg3.isLayoutMarginsRelativeArrangement = true
            desBg3.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    @IBOutlet weak var desBg4: UIStackView! {
        didSet {
            desBg4.isLayoutMarginsRelativeArrangement = true
            desBg4.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    @IBOutlet weak var desBg5: UIStackView! {
        didSet {
            desBg5.isLayoutMarginsRelativeArrangement = true
            desBg5.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    @IBOutlet weak var sectionBg1: UIStackView! {
        didSet {
            sectionBg1.applyCornerRadius(7)
        }
    }
    
    @IBOutlet weak var sectionBg2: UIStackView! {
        didSet {
            sectionBg2.applyCornerRadius(7)
        }
    }
    
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.text = "资产".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.text = "From"
        }
    }
    
    @IBOutlet weak var desLabel3: UILabel! {
        didSet {
            desLabel3.text = "To"
        }
    }
    
    @IBOutlet weak var desLabel4: UILabel! {
        didSet {
            desLabel4.text = "网络费用".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel5: UILabel! {
        didSet {
            desLabel5.text = "最大总计".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel1: UILabel! {
        didSet {
            valueLabel1.text = "--"
        }
    }
    
    @IBOutlet weak var valueLabel2: UILabel! {
        didSet {
            valueLabel2.text = "--"
        }
    }
    
    @IBOutlet weak var valueLabel3: UILabel! {
        didSet {
            valueLabel3.text = "--"
        }
    }
    
    @IBOutlet weak var valueLabel4: UILabel! {
        didSet {
            valueLabel4.text = "--"
        }
    }
    
    @IBOutlet weak var valueLabel5: UILabel! {
        didSet {
            valueLabel5.textColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    @IBOutlet weak var bottomButton: UIButton! {
        didSet {
            bottomButton.setupAPPUISolidStyle(title: "确定".toMultilingualism())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        valueLabel1.text = model?.tokenName
        valueLabel2.text = LocaleWalletManager.shared().TRON?.address
        valueLabel3.text = toAddress
        valueLabel5.text = sendCount
        
        bottomButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let this = self, let amount = Int64(this.sendCount ?? "0"), let address = this.toAddress, let type = this.model else {
                return
            }
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "Token Name".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }
}
