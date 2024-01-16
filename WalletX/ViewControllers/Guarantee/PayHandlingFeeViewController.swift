//
//  PayHandlingFeeViewController.swift
//  WalletX
//
//  Created by 张国忠 on 2023/12/7.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class SectionInputWithDescText: UIView {
    var hideLine: Bool = false {
        didSet {
            verticalLineView.isHidden = hideLine
        }
    }
    
    var hideRightItem: Bool = false {
        didSet {
            rightStackView.isHidden = hideRightItem
        }
    }
    
    var enableInput: Bool = true {
        didSet {
            textField.isEnabled = enableInput
        }
    }
    
    private lazy var sectionTitleLabel: UILabel = UILabel().then { it in
        it.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        it.textColor = ColorConfiguration.blackText.toColor()
        it.textAlignment = .left
    }
    
    private lazy var containerView: UIView = UIView().then { it in
        it.backgroundColor = ColorConfiguration.listBg.toColor()
        it.layer.cornerRadius = 4
        it.clipsToBounds = true
    }
    
    private lazy var stackView: UIStackView = UIStackView().then { it in
        it.axis = .horizontal
        it.distribution = .fill
        it.alignment = .center
        it.spacing = 20
    }
    
    lazy var textField: UITextField = UITextField().then { it in
        it.font = UIFont.systemFont(ofSize: 14)
        it.textColor = ColorConfiguration.blackText.toColor()
    }
    
    private lazy var rightStackView: UIStackView = UIStackView().then { it in
        it.axis = .horizontal
        it.distribution = .fill
        it.alignment = .center
        it.spacing = 10
    }
    
    private lazy var verticalLineView: UIView = UIView().then { it in
        it.backgroundColor = ColorConfiguration.garyLine.toColor()
    }
    
    private lazy var unitLabel: UILabel = UILabel().then { it in
        it.setContentHuggingPriority(.required, for: .horizontal)
        it.text = "USDT"
        it.font = UIFont.systemFont(ofSize: 13)
        it.textColor = ColorConfiguration.blodText.toColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(sectionTitleLabel)
        addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(rightStackView)
        rightStackView.addArrangedSubview(verticalLineView)
        rightStackView.addArrangedSubview(unitLabel)
        
        sectionTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(sectionTitleLabel.snp.bottom).offset(15)
            make.leading.equalTo(sectionTitleLabel.snp.leading)
            make.trailing.equalTo(sectionTitleLabel.snp.trailing)
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        verticalLineView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(18)
        }
    }
    
    func setup(with title: String) {
        sectionTitleLabel.text = title
    }
}

class PayHandlingFeeViewController: UIViewController, HomeNavigationble {
    /// 订单model
    var model: GuaranteeInfoModel.Meta?
    
    private lazy var feeInputItem: SectionInputWithDescText = SectionInputWithDescText().then { it in
        it.setup(with: "多签手续费".toMultilingualism())
    }
    
    private lazy var tipLabel: UILabel = UILabel().then { it in
        it.font = UIFont.systemFont(ofSize: 14)
        it.numberOfLines = 0
    }
    
    private lazy var textContainer: UIView = UIView().then { it in
        it.layer.cornerRadius = 8
        it.backgroundColor = ColorConfiguration.lightBlue.toColor().withAlphaComponent(0.1)
    }
    
    private lazy var stackView: UIStackView = UIStackView().then { it in
        it.axis = .horizontal
        it.alignment = .center
        it.spacing = 30
        it.distribution = .fillEqually
    }
    
    private lazy var innerWalletBtn: UIButton = UIButton(type: .custom).then { it in
        it.setTitle("站内钱包转入".toMultilingualism(), for: .normal)
        it.setTitleColor(.white, for: .normal)
        it.layer.cornerRadius = 4
        it.clipsToBounds = true
        it.backgroundColor = ColorConfiguration.lightBlue.toColor()
        it.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        it.addTarget(self, action: #selector(didInnerWalletBtnClick(button:)), for: .touchUpInside)
    }
    
    private lazy var otherWalletBtn: UIButton = UIButton(type: .custom).then { it in
        it.setTitle("其他钱包转入".toMultilingualism(), for: .normal)
        it.setTitleColor(.white, for: .normal)
        it.layer.cornerRadius = 4
        it.clipsToBounds = true
        it.backgroundColor = ColorConfiguration.primary.toColor()
        it.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        it.addTarget(self, action: #selector(didOtherWalletBtnClick(button:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.backgroundColor = .white
        headerView?.titleLabel.text = "付手续费".toMultilingualism()
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        view.backgroundColor = .white
        view.addSubview(feeInputItem)
        feeInputItem.snp.makeConstraints { make in
            if let headerView = headerView {
                make.top.equalTo(headerView.snp.bottom).offset(20)
            }
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(textContainer)
        textContainer.addSubview(tipLabel)
        textContainer.snp.makeConstraints { make in
            make.top.equalTo(feeInputItem.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        tipLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
        
        setupUI()
        view.addSubview(stackView)
        stackView.addArrangedSubview(innerWalletBtn)
        stackView.addArrangedSubview(otherWalletBtn)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        innerWalletBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        otherWalletBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        feeInputItem.textField.isUserInteractionEnabled = false
        feeInputItem.textField.text = "\(model?.hc ?? "--")"
    }
    
    private func setupUI()  {
        let fee = String(model?.hc ?? "--")
        let tipString = String(format: "付手续费提示语".toMultilingualism(), fee)
        let attr = NSMutableAttributedString(string: tipString)
        attr.addAttribute(.foregroundColor, value: ColorConfiguration.lightBlue.toColor().withAlphaComponent(0.9), range: NSRange(location: 0, length: attr.length))
        let content = NSMutableAttributedString()
        if let tipImage = UIImage(named: "wallet_noti") {
            let textAttachment = NSTextAttachment(image: tipImage)
            let pointSize = tipLabel.font.pointSize
            textAttachment.bounds = CGRect(x: 0, y: -2, width: pointSize, height: pointSize)
            let tipImage = NSAttributedString(attachment: textAttachment)
            content.append(tipImage)
        }
        content.append(NSAttributedString(string: " "))
        content.append(attr)
        tipLabel.attributedText = content
    }
    
    @objc private func didInnerWalletBtnClick(button: UIButton) {
        
        let req: Observable<GuaranteeInfoModel?> = APIProvider.rx.request(.getAssureOrderDetail(assureId: model?.assureId ?? "")).mapModel()
        req.subscribe(onNext: {[weak self] obj in
            guard let this = self else { return }
            
            let vc: SendTokenPageTwoController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.model = LocaleWalletManager.shared().USDT
            vc.toAddress = obj?.data?.hcAddr
            vc.sendType = .business(from: 0, assureId: this.model?.assureId ?? "")
            vc.sendCount = this.feeInputItem.textField.text
            vc.defaultMaxTotal = "20"
            vc.defaultNetworkFee = "10"
            this.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    @objc private func didOtherWalletBtnClick(button: UIButton) {
        let vc: OtherWalletSendController = ViewLoader.Storyboard.controller(from: "Wallet")
        vc.model = model
        vc.payType = .fee
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
