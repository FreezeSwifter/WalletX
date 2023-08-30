//
//  CreateWalletStepTwoController.swift
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


class CreateWalletStepTwoController: UIViewController, HomeNavigationble {

    @IBOutlet weak var notiLabel: UILabel! {
        didSet {
            notiLabel.text = "创建钱包第二步提醒".toMultilingualism()
        }
    }
    
    @IBOutlet weak var waringButton: UIButton!
    
    @IBOutlet weak var layoutView: QMUIFloatLayoutView! {
        didSet {
            layoutView.minimumItemSize = CGSize(width: (layoutView.bounds.size.width - 35) / 2, height: 40)
            layoutView.itemMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        }
    }
    
    @IBOutlet weak var copyButton: UIButton! {
        didSet {
            copyButton.layer.cornerRadius = 4
            copyButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
            copyButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var redLabel: UILabel! {
        didSet {
            redLabel.text = "创建钱包第二步红字".toMultilingualism()
        }
    }
    
    @IBOutlet weak var bottomButton: UIButton! {
        didSet {
            bottomButton.layer.cornerRadius = 10
            bottomButton.setupAPPUISolidStyle(title: "继续".toMultilingualism())
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
            btn.titleLabel?.minimumScaleFactor = 0.8
            btn.applyCornerRadius(7)
            layoutView.addSubview(btn)
        }
        
        bottomButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc: VerifyPhraseController = ViewLoader.Storyboard.controller(from: "Wallet")
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "你的助记词".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    
    }

}
