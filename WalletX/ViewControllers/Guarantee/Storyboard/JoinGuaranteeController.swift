//
//  JoinGuaranteeController.swift
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


class JoinGuaranteeController: UIViewController, HomeNavigationble {

    @IBOutlet weak var topBg: UIStackView!{
        didSet {
            topBg.isLayoutMarginsRelativeArrangement = true
            topBg.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    @IBOutlet weak var topDesLabel: UILabel! {
        didSet {
            topDesLabel.text = "加入担保小喇叭".toMultilingualism()
        }
    }
    
    @IBOutlet weak var idDesLabel: UILabel! {
        didSet {
            idDesLabel.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var idTextField: UITextField! {
        didSet {
            idTextField.text = "请输入担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var redDesLabel: UILabel! {
        didSet {
            redDesLabel.text = "查询失败提示".toMultilingualism()
        }
    }
    
    @IBOutlet weak var scanDesLabel: UILabel! {
        didSet {
            scanDesLabel.text = "通过扫码查询".toMultilingualism()
        }
    }
    
    @IBOutlet weak var scanButton: UIButton! {
        didSet {
            scanButton.setTitle("立即扫码".toMultilingualism(), for: .normal)
            scanButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            scanButton.layer.cornerRadius = 10
            scanButton.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let vc: JoinGuaranteeStepTwoController = ViewLoader.Storyboard.controller(from: "Guarantee")
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    private func bind() {
        scanButton.rx.tap.subscribe(onNext: {[weak self] in
            let scanVC: ScanViewController = ViewLoader.Xib.controller()
            scanVC.scanCompletion {[weak self] text in
                let vc: JoinGuaranteeStepTwoController = ViewLoader.Storyboard.controller(from: "Guarantee")
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            self?.navigationController?.pushViewController(scanVC, animated: true)
        }).disposed(by: rx.disposeBag)
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
