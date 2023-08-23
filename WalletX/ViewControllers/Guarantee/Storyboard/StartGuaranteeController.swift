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

class StartGuaranteeController: UIViewController, HomeNavigationble {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
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
        
        helpButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            
            NotiAlterView.show(title: "什么是多签手续费".toMultilingualism(), content: "多签手续费内容".toMultilingualism(), leftButtonTitle: "联系客服".toMultilingualism(), rightButtonTitle: "知道啦".toMultilingualism()).subscribe(onNext: { index in
                print(index)
                
            }).disposed(by: self.rx.disposeBag)
            
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
        
        multipleButton.snp.makeConstraints { make in
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
