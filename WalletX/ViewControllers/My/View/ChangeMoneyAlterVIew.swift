//
//  ChangeMoneyAlterVIew.swift
//  WalletX
//
//  Created by DZSB-001968 on 28.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx

class ChangeMoneyAlterVIew: UIView {
    
    weak var oc: OverlayController?
    
    @IBOutlet weak var moneyDesLabel: UILabel! {
        didSet {
            moneyDesLabel.text = "担保金额没有1"
        }
    }
    
    @IBOutlet weak var textFeildBg: UIView! {
        didSet {
            textFeildBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var moneyTextField: UITextField! {
        didSet {
            moneyTextField.placeholder = "请输入担保金额".toMultilingualism()
        }
    }
    
    @IBOutlet weak var protocolDesLabel: UILabel! {
        didSet {
            protocolDesLabel.text = "担保协议".toMultilingualism()
        }
    }
    
    private let textViewPlaceholderLabel = UILabel()
    
    @IBOutlet weak var protocolBg: UIView! {
        didSet {
            protocolBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var leftButton: UIButton! {
        didSet {
            leftButton.setTitle("联系对方".toMultilingualism(), for: .normal)
            leftButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            leftButton.layer.cornerRadius = 10
            leftButton.layer.borderWidth = 1
            leftButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
            leftButton.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var rightButton: UIButton! {
        didSet {
            rightButton.setTitle("返回".toMultilingualism(), for: .normal)
            rightButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            rightButton.layer.cornerRadius = 10
            rightButton.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        
        textViewPlaceholderLabel.text = "担保协议占位".toMultilingualism()
        textViewPlaceholderLabel.font = textView.font
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
    
    
    static func show() -> Observable<Int> {
        return Observable<Int>.create { o in
            
            guard let topVc = UIApplication.topViewController() else {
                return Disposables.create {}
            }
            
            let baseHeight: CGFloat = 390
            let width = topVc.view.bounds.width - 80
            let contentView: ChangeMoneyAlterVIew = ViewLoader.Xib.view()
            
            contentView.do { it in
                it.frame = CGRect(x: 0, y: 0, width: width, height: baseHeight)
                it.layer.cornerRadius = 10
                it.leftButton.rx.tap.subscribe(onNext: {[weak it] _ in
                    o.onNext(0)
                    if let oc = it?.oc {
                        topVc.view.dissmiss(overlay: oc)
                    }
                }).disposed(by: it.rx.disposeBag)
                
                it.rightButton.rx.tap.subscribe(onNext: {[weak it] _ in
                    o.onNext(1)
                    if let oc = it?.oc {
                        topVc.view.dissmiss(overlay: oc)
                    }
                }).disposed(by: it.rx.disposeBag)
            }
            
            let ovc = OverlayController(view: contentView)
            ovc.isDismissOnMaskTouched = true
            ovc.layoutPosition = .center
            ovc.presentationStyle = .transform(scale: 1.5)
            ovc.dismissonStyle = .transform(scale: 0.5)
            ovc.maskStyle = .black(opacity: 0.5)
            topVc.view.present(overlay: ovc)
            contentView.oc = ovc
            
            return Disposables.create {}
        }
    }
}

extension ChangeMoneyAlterVIew: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 1000
    }
}
