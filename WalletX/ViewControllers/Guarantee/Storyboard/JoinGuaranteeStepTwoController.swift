//
//  JoinGuaranteeStepTwoController.swift
//  WalletX
//
//  Created by DZSB-001968 on 26.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx

class JoinGuaranteeStepTwoController: UIViewController, HomeNavigationble {

    
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueTextField1: UITextField! {
        didSet {
            valueTextField1.placeholder = "请输入担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.text = "担保类型".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueTextField2: UITextField! {
        didSet {
            valueTextField2.placeholder = "担保类型".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel3: UILabel! {
        didSet {
            desLabel3.text = "home_amount".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueTextField3: UITextField! {
        didSet {
            valueTextField3.placeholder = "请输入担保金额".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel4: UILabel! {
        didSet {
            desLabel4.text = "担保协议".toMultilingualism()
        }
    }
    
    @IBOutlet weak var pasteButton: UIButton!
    
    @IBOutlet weak var textViewBg: UIView! {
        didSet {
            textViewBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var agreeButton: UIButton! {
        didSet {
            agreeButton.setTitle("加入担保同意".toMultilingualism(), for: .normal)
            agreeButton.setImage(UIImage(named: "guarantee_check_box1"), for: .normal)
            agreeButton.setImage(UIImage(named: "guarantee_check_box2"), for: .selected)
            agreeButton.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: .normal)
            agreeButton.titleLabel?.minimumScaleFactor = 0.8
            agreeButton.titleLabel?.adjustsFontSizeToFitWidth = true
            agreeButton.centerTextAndImage(spacing: 8)
        }
    }
    
    @IBOutlet weak var contactButton: UIButton! {
        didSet {
            contactButton.setTitle("联系对方".toMultilingualism(), for: .normal)
            contactButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            contactButton.layer.cornerRadius = 10
            contactButton.layer.borderWidth = 1
            contactButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
            contactButton.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var joinButton: UIButton! {
        didSet {
            joinButton.setTitle("加入".toMultilingualism(), for: .normal)
            joinButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            joinButton.layer.cornerRadius = 10
            joinButton.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }
    
    private let textViewPlaceholderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }
    
    private func bind() {
        agreeButton.rx.tap.subscribe(onNext: {[unowned self] in
            
            self.agreeButton.isSelected = !self.agreeButton.isSelected
            
        }).disposed(by: rx.disposeBag)
        
        joinButton.rx.tap.subscribe(onNext: {[unowned self] in
            
            GuaranteeYesNoView.showFromBottom(image: UIImage(named: "guarantee_celebration"), title: "成功加入担保弹窗标题".toMultilingualism(), titleIcon: nil, content: "成功加入担保弹窗内容".toMultilingualism(), leftButton: "提醒对方上押".toMultilingualism(), rightButton: "我来上押".toMultilingualism()).subscribe(onNext: { index in
           
                
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        textViewPlaceholderLabel.text = "担保协议占位".toMultilingualism()
        textViewPlaceholderLabel.font = self.textView.font
        textViewPlaceholderLabel.sizeToFit()
        textView.addSubview(textViewPlaceholderLabel)
        textViewPlaceholderLabel.frame.origin = CGPoint(x: 0, y: (textView.font?.pointSize)! / 2)
        textViewPlaceholderLabel.textColor = ColorConfiguration.descriptionText.toColor()
        textViewPlaceholderLabel.isHidden = !textView.text.isEmpty
        textView.delegate = self
        
        textView.rx.didChange.subscribe(onNext: {[weak self] in
            self?.textViewPlaceholderLabel.isHidden = !(self?.textView.text.isEmpty ?? false)
        }).disposed(by: rx.disposeBag)
        
        textView.rx.didEndEditing.subscribe(onNext: {[weak self] in
            self?.textViewPlaceholderLabel.isHidden = !(self?.textView.text.isEmpty ?? false)
        }).disposed(by: rx.disposeBag)
        
        textView.rx.didBeginEditing.subscribe(onNext: {[weak self] in
            self?.textViewPlaceholderLabel.isHidden = true
        }).disposed(by: rx.disposeBag)
        
        textView.rx.text.map { "\($0?.count.description ?? "")" + "/1000" }.bind(to: countLabel.rx.text).disposed(by: rx.disposeBag)
    }

    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "home_joinGuaranty".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }
}


extension JoinGuaranteeStepTwoController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 1000
    }
}
