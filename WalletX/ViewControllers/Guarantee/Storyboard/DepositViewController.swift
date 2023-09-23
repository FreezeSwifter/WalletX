//
//  DepositViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 24.9.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx
import Action


class DepositViewController: UIViewController, HomeNavigationble {

    @IBOutlet weak var DesLabel1: UILabel! {
        didSet {
            DesLabel1.text = "待上押担保".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel1: UITextField! {
        didSet {
            valueLabel1.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var valueControl1: UIControl!
    
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desTagLabel2: QMUILabel! {
        didSet {
            desTagLabel2.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
            desTagLabel2.backgroundColor = UIColor(hex: "#F0A1581A").withAlphaComponent(0.1)
            desTagLabel2.applyCornerRadius(desTagLabel2.bounds.height / 2)
            desTagLabel2.text = "me_depositing".toMultilingualism()
            desTagLabel2.textColor = UIColor(hex: "#F0A158")
            desTagLabel2.backgroundColor = UIColor(hex: "#F0A158").withAlphaComponent(0.1)
        }
    }
    
    @IBOutlet weak var desTagContainer3: UIStackView! {
        didSet {
            desTagContainer3.isLayoutMarginsRelativeArrangement = true
            desTagContainer3.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            desTagContainer3.applyCornerRadius(desTagContainer3.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        }
    }
    
    @IBOutlet weak var desTagLabel3: UILabel! {
        didSet {
            desTagLabel3.text = "协议".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valeLabel2: UITextField! {
        didSet {
            valeLabel2.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var desLabel3: UILabel! {
        didSet {
            desLabel3.text = "发起时间".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel3: UITextField! {
        didSet {
            valueLabel3.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var desLabel4: UILabel! {
        didSet {
            desLabel4.text = "担保金额没有1".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel4: UITextField! {
        didSet {
            valueLabel4.isUserInteractionEnabled = false
            valueLabel4.textColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    @IBOutlet weak var desLabel5: UILabel! {
        didSet {
            desLabel5.text = "钱包余额".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel5Sub2: UITextField! {
        didSet {
            valueLabel5Sub2.isUserInteractionEnabled = false
            valueLabel5Sub2.textColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    @IBOutlet weak var valueLabel5Sub1: UITextField! {
        didSet {
            valueLabel5Sub1.isUserInteractionEnabled = false
            valueLabel5Sub1.textColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    
    @IBOutlet weak var waringStackView: UIStackView! {
        didSet {
            waringStackView.isLayoutMarginsRelativeArrangement = true
            waringStackView.layoutMargins = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        }
    }
    
    @IBOutlet weak var waringLabel: UILabel! {
        didSet {
            waringLabel.text = "上押温馨提示".toMultilingualism()
        }
    }
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setupAPPUISolidStyle(title: "下一步".toMultilingualism())
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
        view.backgroundColor = ColorConfiguration.listBg.toColor()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.backgroundColor = ColorConfiguration.wihteText.toColor()
        headerView?.titleLabel.text = "wallet_deposit".toMultilingualism()
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }

}
