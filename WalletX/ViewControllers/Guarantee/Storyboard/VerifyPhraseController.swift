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
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var displayLayoutView: QMUIFloatLayoutView! {
        didSet {
            displayLayoutView.itemMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            displayLayoutView.padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
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
        ["东野圭吾", "三体", "爱", "红楼梦", "理智与情感", "读书热榜", "免费榜","爱", "红楼梦", "理智与情感", "读书热榜", "免费榜"].enumerated().forEach { i, str in
            let btn = QMUIButton(type: .custom)
            btn.backgroundColor = ColorConfiguration.homeItemBg.toColor()
            btn.setTitle("\(i.description)  \(str)", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            btn.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: .normal)
            btn.titleLabel?.minimumScaleFactor = 0.5
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.applyCornerRadius(7)
            btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
            selectedLayoutView.addSubview(btn)
            
        }
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "验证助记词".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
    }
    
}
