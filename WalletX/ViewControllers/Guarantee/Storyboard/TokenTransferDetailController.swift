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
import SwiftDate

class TokenTransferDetailController: UIViewController, HomeNavigationble {
    
    var isFrmoTransferListPage: Bool = false
    var item: WalletToken?
    var model: TokenTecordTransferModel?
    var txid: String?
    var toAddress: String?
    var sendAmount: String?
    
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
    
    @IBOutlet weak var valueLabel1: UILabel! {
        didSet {
            valueLabel1.text = Date().toRelative(style: RelativeFormatter.twitterStyle())
        }
    }
    
    @IBOutlet weak var valueLabel2: UILabel! {
        didSet {
            valueLabel2.text = "完成".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel3: UILabel! {
        didSet {
            valueLabel3.adjustsFontSizeToFitWidth = true
            valueLabel3.minimumScaleFactor = 0.7
        }
    }
    
    @IBOutlet weak var valueLabel4: UILabel!
    
    @IBOutlet weak var checkButton: UIButton! {
        didSet {
            checkButton.setTitle("在区块浏览器上查看".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var unitLabel: UILabel! {
        didSet {
            unitLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var successImageView: UIImageView! {
        didSet {
            successImageView.isHidden = true
        }
    }
    
    private lazy var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large).then { it in
        it.hidesWhenStopped = true
        it.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        if isFrmoTransferListPage {
            if model?.from == LocaleWalletManager.shared().TRON?.address {
                topLabel.text = "-\(model?.amount ?? 0) \(item?.tokenName ?? "--")"
                
            } else if model?.to == LocaleWalletManager.shared().TRON?.address {
                topLabel.text = "+\(model?.amount ?? 0) \(item?.tokenName ?? "--")"
            }
            valueLabel4.text = model?.fee
            successImageView.isHidden = false
            indicator.stopAnimating()
            valueLabel3.text = model?.to
            
        } else {
            topLabel.text = "-\(sendAmount ?? "--") \(item?.tokenName ?? "--")"
            valueLabel3.text = toAddress
            valueLabel4.text = "--"
        }
        
        
        APIProvider.rx.request(.getTXInfo(txId: txid ?? "")).mapStringValue()
            .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] str in
                
                self?.valueLabel4.text = str
                self?.successImageView.isHidden = false
                self?.indicator.stopAnimating()
            }).disposed(by: rx.disposeBag)
        
        checkButton.rx.tap.subscribe(onNext: { _ in
            //        https://tronscan.org/#/transaction/xxx
            //        https://nile.tronscan.org/#/transaction/xxx
            if let url = URL(string: "https://tronscan.org/#/transaction/xxx") {
                UIApplication.shared.open(url)
            }
            
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = ColorConfiguration.listBg.toColor()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "转账".toMultilingualism()
        
        view.addSubview(indicator)
        indicator.center = successImageView.center
    }
}
