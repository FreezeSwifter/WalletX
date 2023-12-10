//
//  TokenTransferDetailController.swift
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

class TokenTransferDetailController: UIViewController, HomeNavigationble {
    
    var item: WalletToken?
    var model: TokenTecordTransferModel?
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var stackBg1: UIStackView!
    
    @IBOutlet weak var stackBg2: UIStackView!
    
    @IBOutlet weak var desBg1: UIStackView! {
        didSet {
            desBg1.isLayoutMarginsRelativeArrangement = true
            desBg1.layoutMargins = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        }
    }
    
    @IBOutlet weak var desBg2: UIStackView! {
        didSet {
            desBg2.isLayoutMarginsRelativeArrangement = true
            desBg2.layoutMargins = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        }
    }
    
    @IBOutlet weak var desBg3: UIStackView! {
        didSet {
            desBg3.isLayoutMarginsRelativeArrangement = true
            desBg3.layoutMargins = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        }
    }
    
    @IBOutlet weak var desBg4: UIStackView! {
        didSet {
            desBg4.isLayoutMarginsRelativeArrangement = true
            desBg4.layoutMargins = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        }
    }
    
    
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.text = "日期".toMultilingualism()
            desLabel1.minimumScaleFactor = 0.8
            desLabel1.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.text = "状态".toMultilingualism()
            desLabel2.minimumScaleFactor = 0.8
            desLabel2.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var desLabel3: UILabel! {
        didSet {
            desLabel3.text = "接收者".toMultilingualism()
            desLabel3.minimumScaleFactor = 0.8
            desLabel3.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var desLabel4: UILabel! {
        didSet {
            desLabel4.text = "网络费用".toMultilingualism()
            desLabel4.minimumScaleFactor = 0.8
            desLabel4.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel1: UILabel!
    
    @IBOutlet weak var valueLabel2: UILabel!
    
    @IBOutlet weak var valueLabel3: UILabel!
    
    @IBOutlet weak var valueLabel4: UILabel!
    
    @IBOutlet weak var checkButton: UIButton! {
        didSet {
            checkButton.setTitle("在区块浏览器上查看".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var unitLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        topLabel.text = "\(model?.amount ?? 0)"
        valueLabel1.text = model?.assetName
        valueLabel2.text = model?.from
        valueLabel3.text = model?.to
        valueLabel4.text = "--"
        
        desLabel1.text = "资产".toMultilingualism()
        desLabel2.text = "From"
        desLabel3.text = "To"
        desLabel3.text = "网络费用".toMultilingualism()
        
        unitLabel.text = model?.assetName
        
        APIProvider.rx.request(.getTXInfo(txId: model?.txid ?? "")).mapStringValue()
            .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] str in
            self?.valueLabel4.text = str
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = ColorConfiguration.listBg.toColor()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "转账".toMultilingualism()
    }
}
