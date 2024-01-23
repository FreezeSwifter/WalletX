//
//  VerifyPhraseController.swift
//  WalletX
//
//  Created by DZSB-001968 on 30.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx


class VerifyPhraseController: UIViewController, HomeNavigationble {
    
    var mnemoicList: [String] = []
    
    private var selectedList: [String] = []
    private var displayedList: [String] = []
    
    private let nextButtonEnable = BehaviorSubject(value: false)
    
    @IBOutlet weak var topLabel: UILabel! {
        didSet {
            topLabel.text = "验证助记词顶部提示".toMultilingualism()
        }
    }
    
    @IBOutlet weak var displayLayoutView: QMUIFloatLayoutView! {
        didSet {
            displayLayoutView.itemMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            displayLayoutView.padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
    }
    
    @IBOutlet weak var selectedLayoutView: QMUIFloatLayoutView! {
        didSet {
            selectedLayoutView.itemMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            selectedLayoutView.padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    @IBOutlet weak var verifyButton: UIButton! {
        didSet {
            verifyButton.layer.cornerRadius = 10
            verifyButton.setupAPPUISolidStyle(title: "继续".toMultilingualism())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        selectedList = mnemoicList.shuffled()
        selectedList.enumerated().forEach { i, str in
            let btn = QMUIButton(type: .custom)
            btn.setTitle(str, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            btn.setTitleColor(ColorConfiguration.blackText.toColor(), for: .normal)
            btn.titleLabel?.minimumScaleFactor = 0.5
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.layer.borderWidth = 1
            btn.layer.borderColor = ColorConfiguration.garyLine.toColor().withAlphaComponent(0.8).cgColor
            btn.applyCornerRadius(4)
            btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
            selectedLayoutView.addSubview(btn)
            btn.addTarget(self, action: #selector(VerifyPhraseController.selectedLayoutViewTap(sender:)), for: .touchUpInside)
        }
        
        nextButtonEnable.subscribe(onNext: {[weak self] isEnabled in
            self?.verifyButton.isEnabled = isEnabled
        }).disposed(by: rx.disposeBag)
        
        verifyButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let this = self else { return }
            let result = this.displayedList.map { itemStr in
                let handleStr = itemStr.components(separatedBy: CharacterSet.decimalDigits).last?.trimmingCharacters(in: .whitespaces) ?? ""
                return handleStr
            }
            if result.joined() == this.mnemoicList.joined() {
                
                GuaranteeYesNoView.showFromBottom(image: UIImage(named: "guarantee_celebration"), title: "创建钱包成功".toMultilingualism(), titleIcon: nil, content: "创建钱包成功子标题".toMultilingualism(), leftButton: nil,rightButton: "立即体验".toMultilingualism()).subscribe(onNext: { index in
               
                    LocaleWalletManager.shared().save(isNotActiveAccount: true)
                    this.navigationController?.popToRootViewController(animated: true)
                    
                }).disposed(by: this.rx.disposeBag)
                
                
            } else {
                APPHUD.flash(text: "验证助记词错误提示".toMultilingualism())
            }
            
        }).disposed(by: rx.disposeBag)
    }
    
    private func reloadLayoutView() {
        selectedLayoutView.subviews.forEach { $0.removeFromSuperview() }
        displayLayoutView.subviews.forEach { $0.removeFromSuperview() }
        
        selectedList.enumerated().forEach { i, str in
            let btn = QMUIButton(type: .custom)
            btn.setTitle(str, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            btn.setTitleColor(ColorConfiguration.blackText.toColor(), for: .normal)
            btn.titleLabel?.minimumScaleFactor = 0.5
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.layer.borderWidth = 1
            btn.layer.borderColor = ColorConfiguration.garyLine.toColor().withAlphaComponent(0.8).cgColor
            btn.applyCornerRadius(4)
            btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
            selectedLayoutView.addSubview(btn)
            btn.tag = i
            btn.addTarget(self, action: #selector(VerifyPhraseController.selectedLayoutViewTap(sender:)), for: .touchUpInside)
        }
        
        displayedList.enumerated().forEach { i, str in
            let btn = QMUIButton(type: .custom)
            btn.setTitle("\(i + 1) \(str)", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            btn.setTitleColor(ColorConfiguration.blackText.toColor(), for: .normal)
            btn.titleLabel?.minimumScaleFactor = 0.5
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.layer.borderWidth = 1
            btn.layer.borderColor = ColorConfiguration.garyLine.toColor().withAlphaComponent(0.8).cgColor
            btn.applyCornerRadius(4)
            btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
            displayLayoutView.addSubview(btn)
            btn.tag = i
            btn.addTarget(self, action: #selector(VerifyPhraseController.displayedLayoutViewTap(sender:)), for: .touchUpInside)
        }
    }
    
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "验证助记词".toMultilingualism()
        headerView?.backgroundColor = .white
    }
    
    
    @objc
    private func selectedLayoutViewTap(sender: QMUIButton) {
        guard let str = sender.titleLabel?.text else {
            return
        }
        
        if let deleteIndex = selectedList.firstIndex(where: { item in
            return item == str
        }) {
            selectedList.remove(at: deleteIndex)
            displayedList.append("\(str)")
        }
        
        reloadLayoutView()
        nextButtonEnable.onNext(displayedList.count == mnemoicList.count)
    }
    
    @objc
    private func displayedLayoutViewTap(sender: QMUIButton) {
        
        guard let str = sender.titleLabel?.text else {
            return
        }
        
        let handleStr = str.components(separatedBy: CharacterSet.decimalDigits).last?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if let deleteIndex = displayedList.firstIndex(where: { item in
            
            return item == handleStr
        }) {
            displayedList.remove(at: deleteIndex)
            selectedList.append(handleStr)
        }
        
        reloadLayoutView()
        nextButtonEnable.onNext(displayedList.count == mnemoicList.count)
    }
}
