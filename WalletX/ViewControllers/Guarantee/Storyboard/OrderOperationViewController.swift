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
    
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.text = "发起时间".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel3: UILabel! {
        didSet {
            desLabel3.text = "担保金额没有1".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel4: UILabel! {
        didSet {
            desLabel4.text = "发起人".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel5Me: UILabel! {
        didSet {
            desLabel5Me.text = "我".toMultilingualism()
            desLabel5Me.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            desLabel5Me.minimumScaleFactor = 0.5
            desLabel5Me.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var desLabel5: UILabel! {
        didSet {
            desLabel5.text = "参与人".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel1: UILabel!
    
    @IBOutlet weak var valueLabel1State: UILabel!
    
    @IBOutlet weak var valueLabel2: UILabel!
    
    @IBOutlet weak var valueLabel3: UILabel!
    
    @IBOutlet weak var valueLabel4: UILabel!
    
    @IBOutlet weak var valueLabel5: UILabel!
    
    @IBOutlet weak var protocolBg: UIStackView! {
        didSet {
            protocolBg.isLayoutMarginsRelativeArrangement = true
            protocolBg.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            protocolBg.applyCornerRadius(protocolBg.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        }
    }
    
    @IBOutlet weak var protocolLabel: UILabel! {
        didSet {
            protocolLabel.text = "协议".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel4Sub: UILabel!
    
    @IBOutlet weak var valueLabel5Sub: UILabel!
    
    
    @IBOutlet weak var desLabel6: UILabel! {
        didSet {
            desLabel6.text = "担保时长".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel7: UILabel! {
        didSet {
            desLabel7.text = "担保费用".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel8: UILabel! {
        didSet {
            desLabel8.text = "可解金额".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel9: UILabel! {
        didSet {
            desLabel9.text = "解押原因".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel10: UILabel! {
        didSet {
            desLabel10.text = "收款账户".toMultilingualism()
        }
    }
    
    var state: OrderOperationGuarantee = .applyRelease {
        didSet {
            headerView?.titleLabel.text = state.title
        }
    }
    
    @IBOutlet weak var tradeCompletedButton: QMUIButton! {
        didSet {
            tradeCompletedButton.setImage(UIImage(named: "me_checkbox2"), for: .selected)
            tradeCompletedButton.setTitle("交易结束".toMultilingualism(), for: .normal)
            tradeCompletedButton.isSelected = true
            tradeCompletedButton.spacingBetweenImageAndTitle = 10
        }
    }
    
    @IBOutlet weak var tradeCancelButton: QMUIButton! {
        didSet {
            tradeCancelButton.setImage(UIImage(named: "me_checkbox2"), for: .selected)
            tradeCancelButton.setTitle("交易取消".toMultilingualism(), for: .normal)
            tradeCancelButton.spacingBetweenImageAndTitle = 10
        }
    }
    
    @IBOutlet weak var explainButton: QMUIButton! {
        didSet {
            explainButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            explainButton.spacingBetweenImageAndTitle = 4
            explainButton.backgroundColor = ColorConfiguration.primary.toColor().withAlphaComponent(0.1)
            explainButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            explainButton.setTitle("说明".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var accountButton1: QMUIButton! {
        didSet {
            accountButton1.setImage(UIImage(named: "guarantee_check_box2"), for: .selected)
            accountButton1.isSelected = true
            accountButton1.spacingBetweenImageAndTitle = 10
        }
    }
    
    @IBOutlet weak var accountButton2: QMUIButton! {
        didSet {
            accountButton2.setImage(UIImage(named: "guarantee_check_box2"), for: .selected)
            accountButton2.spacingBetweenImageAndTitle = 10
        }
    }
    
    @IBOutlet weak var valueLabel6: UILabel!
    
    @IBOutlet weak var valueLabel7: UILabel!
    
    @IBOutlet weak var valueLabel8: UILabel!
    
    @IBOutlet weak var textFieldBg1: UIView! {
        didSet {
            textFieldBg1.clipsToBounds = true
            textFieldBg1.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var textFieldBg2: UIView! {
        didSet {
            textFieldBg2.clipsToBounds = true
            textFieldBg2.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var textField1: UITextField!
    
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var walletDesLabel: UILabel! {
        didSet {
            walletDesLabel.text = "钱包账户".toMultilingualism()
        }
    }
    
    @IBOutlet weak var walletBg: UIView! {
        didSet {
            walletBg.clipsToBounds = true
            walletBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var walletTextField: UITextField! {
        didSet {
            walletTextField.placeholder = nil
            walletTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var addressCopyButton: UIButton! {
        didSet {
            addressCopyButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var buttonLeftButton: UIButton! {
        didSet {
            buttonLeftButton.setupAPPUIHollowStyle(title: "联系对方".toMultilingualism())
        }
    }
    
    @IBOutlet weak var bottomRightButton: UIButton! {
        didSet {
            bottomRightButton.setupAPPUISolidStyle(title: "立即申请".toMultilingualism())
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
        
        desLabel5Me.snp.remakeConstraints { make in
            make.width.height.equalTo(26)
        }
        desLabel5Me.clipsToBounds = true
        desLabel5Me.layer.cornerRadius = 13
    }
}
