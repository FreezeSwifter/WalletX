//
//  StartGuaranteeController.swift
//  WalletX
//
//  Created by DZSB-001968 on 23.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx
import HandyJSON

extension StartGuaranteeController {
    
    class Parameter: HandyJSON {
        required init() {}
        var amount: String?
        var agreement: String?
        var assureType: Int?
        var hc: Double?
        var hcAddr: String?
    }
}

class StartGuaranteeController: UIViewController, HomeNavigationble {
    
    private let parameter: Parameter = Parameter()
    
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.textColor = ColorConfiguration.blackText.toColor()
            desLabel1.text = "担保金额".toMultilingualism()
        }
    }
    
    @IBOutlet weak var moneyContainerView: UIView! {
        didSet {
            moneyContainerView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var moneyTextField: UITextField! {
        didSet {
            moneyTextField.placeholder = "请输入担保金额".toMultilingualism()
            moneyTextField.keyboardType = .decimalPad
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.textColor = ColorConfiguration.blackText.toColor()
            desLabel2.text = "担保协议".toMultilingualism()
        }
    }
    
    @IBOutlet weak var contracContainerView: UIView! {
        didSet {
            contracContainerView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var textView: UITextView!
    private let textViewPlaceholderLabel = UILabel()
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var bottomContainerView: UIView! {
        didSet {
            bottomContainerView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var desLabel3: UILabel! {
        didSet {
            desLabel3.textColor = ColorConfiguration.blackText.toColor()
            desLabel3.text = "担保类型".toMultilingualism()
        }
    }
    
    @IBOutlet weak var normalButton: UIButton! {
        didSet {
            normalButton.setTitle("普通担保".toMultilingualism(), for: .normal)
            normalButton.setImage(UIImage(named: "guarantee_check_box2"), for: .selected)
            normalButton.isSelected = true
        }
    }
    
    @IBOutlet weak var normalLabel1: UILabel! {
        didSet {
            normalLabel1.text = "普通担保tag1".toMultilingualism()
        }
    }
    
    @IBOutlet weak var normalLabel2: UILabel! {
        didSet {
            normalLabel2.text = "普通担保tag2".toMultilingualism()
        }
    }
    
    @IBOutlet weak var normalDesLabel: UILabel! {
        didSet {
            normalDesLabel.text = "普通担保des".toMultilingualism()
            normalDesLabel.textColor = ColorConfiguration.descriptionText.toColor()
        }
    }
    
    @IBOutlet weak var multipleButton: UIButton! {
        didSet {
            multipleButton.setTitle("多签担保".toMultilingualism(), for: .normal)
            multipleButton.setImage(UIImage(named: "guarantee_check_box2"), for: .selected)
        }
    }
    
    @IBOutlet weak var multipleLabel1: UILabel! {
        didSet {
            multipleLabel1.text = "多签担保tag1".toMultilingualism()
        }
    }
    
    @IBOutlet weak var multipleLabel2: UILabel! {
        didSet {
            multipleLabel2.text = "多签担保tag1".toMultilingualism()
        }
    }
    
    @IBOutlet weak var multipleDesLabel: UILabel! {
        didSet {
            multipleDesLabel.textColor = ColorConfiguration.descriptionText.toColor()
            multipleDesLabel.text = "多签担保des".toMultilingualism()
        }
    }
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.backgroundColor = ColorConfiguration.primary.toColor()
            nextButton.setTitle("下一步".toMultilingualism(), for: .normal)
            nextButton.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var helpButton: UIButton! {
        didSet {
            helpButton.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var tagBg1: UIStackView! {
        didSet {
            tagBg1.layer.cornerRadius = 10
            tagBg1.isLayoutMarginsRelativeArrangement = true
            tagBg1.layoutMargins = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        }
    }
    
    @IBOutlet weak var tagBg2: UIStackView! {
        didSet {
            tagBg2.layer.cornerRadius = 10
            tagBg2.isLayoutMarginsRelativeArrangement = true
            tagBg2.layoutMargins = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        }
    }
    
    @IBOutlet weak var tagBg3: UIStackView! {
        didSet {
            tagBg3.layer.cornerRadius = 10
            tagBg3.isLayoutMarginsRelativeArrangement = true
            tagBg3.layoutMargins = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        }
    }
    
    @IBOutlet weak var tagBg4: UIStackView! {
        didSet {
            tagBg4.layer.cornerRadius = 10
            tagBg4.isLayoutMarginsRelativeArrangement = true
            tagBg4.layoutMargins = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
//        TXhcz9yLurPQ4fqEfzS3zCycfzJSdZkZwC
        textViewPlaceholderLabel.text = "担保协议占位".toMultilingualism()
        textViewPlaceholderLabel.font = self.textView.font
        textViewPlaceholderLabel.sizeToFit()
        textView.addSubview(textViewPlaceholderLabel)
        textViewPlaceholderLabel.frame.origin = CGPoint(x: 0, y: (textView.font?.pointSize)! / 2)
        textViewPlaceholderLabel.textColor = ColorConfiguration.descriptionText.toColor()
        textViewPlaceholderLabel.isHidden = !textView.text.isEmpty
        textView.delegate = self
        
        moneyTextField.rx.text.subscribe(onNext: {[weak self] text in
            self?.parameter.amount = text
        }).disposed(by: rx.disposeBag)
        
        textView.rx.didChange.subscribe(onNext: {[weak self] in
            self?.textViewPlaceholderLabel.isHidden = !(self?.textView.text.isEmpty ?? false)
            self?.parameter.agreement = self?.textView.text
        }).disposed(by: rx.disposeBag)
        
        textView.rx.didEndEditing.subscribe(onNext: {[weak self] in
            self?.textViewPlaceholderLabel.isHidden = !(self?.textView.text.isEmpty ?? false)
        }).disposed(by: rx.disposeBag)
        
        textView.rx.didBeginEditing.subscribe(onNext: {[weak self] in
            self?.textViewPlaceholderLabel.isHidden = true
        }).disposed(by: rx.disposeBag)
        
        textView.rx.text.map { "\($0?.count.description ?? "")" + "/1000" }.bind(to: countLabel.rx.text).disposed(by: rx.disposeBag)
        
        helpButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            
            NotiAlterView.show(title: "什么是多签手续费".toMultilingualism(), content: "多签手续费内容".toMultilingualism(), leftButtonTitle: "联系客服".toMultilingualism(), rightButtonTitle: "知道啦".toMultilingualism()).subscribe(onNext: { index in
                print(index)
                
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        nextButton.rx.tap.subscribe(onNext: { [weak self] in
            
            if self?.parameter.agreement?.count == 0 || self?.parameter.amount?.count == 0 {
                APPHUD.flash(text: "请检查输入项".toMultilingualism())
                return
            }
            guard let this = self, let param = this.parameter.toJSON() else { return }
            
            APIProvider.rx.request(.assureOrderLaunch(parameter: param)).mapJSON().asObservable()
                .subscribe(onNext: {[weak self] obj in
                    guard let this2 = self, let dict = obj as? [String: Any], let data = dict["data"] as? [String: Any] else { return }
                    let assureId = data["assureId"] as? String ?? ""
                    let amount = data["amount"] as? Double ?? 0
                    if this2.parameter.assureType == 0 { // 普通
                        let vc: InviteGuaranteeController = ViewLoader.Storyboard.controller(from: "Guarantee")
                        var m =  GuaranteeInfoModel.Meta()
                        m.amount = amount
                        m.assureId = assureId
                        vc.model = m
                        this2.navigationController?.pushViewController(vc, animated: true)
                        NotificationCenter.default.post(name: .orderDidChangeed, object: nil)
                    } else { // 多钱手续费
                        let vc: StartGuaranteeConfirmController = ViewLoader.Storyboard.controller(from: "Guarantee")
                        vc.parameter = self?.parameter
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    if dict["message"] as? String != "Success" {
                        APPHUD.flash(text: dict["message"] as? String)
                    }
                    
                }).disposed(by: this.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        parameter.assureType = 0
        
        multipleButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let this = self else { return }
            this.multipleButton.isSelected = true
            this.normalButton.isSelected = false
            this.parameter.assureType = 1
            
        }).disposed(by: rx.disposeBag)
        
        normalButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let this = self else { return }
            this.multipleButton.isSelected = false
            this.normalButton.isSelected = true
            this.parameter.assureType = 0
            
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "home_newGuaranty".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        normalButton.snp.remakeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(normalButton.frame.width + 16)
        }
        
        multipleButton.snp.remakeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(200)
        }
    }
}

extension StartGuaranteeController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 1000
    }
}
