//
//  TransferOnsiteWalletController.swift
//  WalletX
//
//  Created by 张国忠 on 2023/12/9.
//

import UIKit
import SnapKit
import RxSwift

class TransferOnsiteWalletController: UIViewController, HomeNavigationble {
    
    var model: GuaranteeInfoModel.Meta? {
        didSet {
            configUI()
        }
    }
    
    private lazy var scrollView: UIScrollView = UIScrollView().then { it in
        it.backgroundColor = .white
    }
    
    private lazy var contentView: UIView = UIView().then { it in
        it.backgroundColor = .white
    }
    
    private lazy var guaranteeIDItem: SectionInputWithDescText = SectionInputWithDescText().then { it in
        it.setup(with: "担保ID".toMultilingualism())
        it.hideRightItem = true
        it.enableInput = false
    }
    
    private lazy var sponsorItem: SectionInputWithDescText = SectionInputWithDescText().then { it in
        it.setup(with: "发起人".toMultilingualism())
        it.hideRightItem = true
        it.enableInput = false
    }
    
    private lazy var startTimeItem: SectionInputWithDescText = SectionInputWithDescText().then { it in
        it.setup(with: "发起时间".toMultilingualism())
        it.hideRightItem = true
        it.enableInput = false
    }
    
    private lazy var guaranteeTypeItem: SectionInputWithDescText = SectionInputWithDescText().then { it in
        it.setup(with: "担保类型没有3".toMultilingualism())
        it.hideRightItem = true
        it.enableInput = false
    }
    
    private lazy var guaranteeAmountItem: SectionInputWithDescText = SectionInputWithDescText().then { it in
        it.setup(with: "担保金额没有1".toMultilingualism())
        it.enableInput = false
    }
    
    private lazy var inputItem: SectionInputWithDescText = SectionInputWithDescText().then { it in
        it.setup(with: "请输入上押金额".toMultilingualism())
        it.hideLine = true
        it.textField.textColor = ColorConfiguration.lightBlue.toColor()
    }
    
    private lazy var walletBalanceItem: SectionInputWithDescText = SectionInputWithDescText().then { it in
        it.setup(with: "钱包余额".toMultilingualism())
        it.hideLine = true
        it.enableInput = false
        it.textField.textColor = ColorConfiguration.lightBlue.toColor()
    }
    
    private lazy var payBtn: UIButton = UIButton(type: .custom).then { it in
        it.setTitle("立即转入".toMultilingualism(), for: .normal)
        it.setTitleColor(.white, for: .normal)
        it.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        it.layer.cornerRadius = 4
        it.clipsToBounds = true
        it.backgroundColor = ColorConfiguration.primary.toColor()
        it.addTarget(self, action: #selector(pay), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "站内钱包转入".toMultilingualism()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(guaranteeIDItem)
        contentView.addSubview(sponsorItem)
        contentView.addSubview(startTimeItem)
        contentView.addSubview(guaranteeTypeItem)
        contentView.addSubview(guaranteeAmountItem)
        contentView.addSubview(inputItem)
        contentView.addSubview(walletBalanceItem)
        view.addSubview(payBtn)
        scrollView.snp.makeConstraints { make in
            if let headerView = headerView {
                make.top.equalTo(headerView.snp.bottom)
            }
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(payBtn.snp.top).offset(-20)
        }
        
        guaranteeIDItem.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        sponsorItem.snp.makeConstraints { make in
            make.top.equalTo(guaranteeIDItem.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        startTimeItem.snp.makeConstraints { make in
            make.top.equalTo(sponsorItem.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        guaranteeTypeItem.snp.makeConstraints { make in
            make.top.equalTo(startTimeItem.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        guaranteeAmountItem.snp.makeConstraints { make in
            make.top.equalTo(guaranteeTypeItem.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        inputItem.snp.makeConstraints { make in
            make.top.equalTo(guaranteeAmountItem.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        walletBalanceItem.snp.makeConstraints { make in
            make.top.equalTo(inputItem.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        payBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    private func configUI() {
        guaranteeIDItem.textField.text = model?.assureId
        sponsorItem.textField.text = model?.sponsorUser
        startTimeItem.textField.text = Date(timeIntervalSince1970: (model?.createTime ?? 0) / 1000).toFormat("yyyy-MM-dd HH:mm:ss")
        guaranteeTypeItem.textField.text = model?.assureTypeToString()
        guaranteeAmountItem.textField.text = String(model?.amount ?? 0)
        LocaleWalletManager.shared().walletBalance.subscribe(onNext: {[weak self] obj in
            self?.walletBalanceItem.textField.text = "\(obj?.data?.USDT ?? "")"
        }).disposed(by: rx.disposeBag)
    }
    
    @objc private func pay() {
        
    }
}
