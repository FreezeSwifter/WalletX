//
//  CreateWalletStepOneController.swift
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
import Action

class CreateWalletStepOneController: UIViewController, HomeNavigationble {
    
    @IBOutlet weak var topTitleLabel: UILabel! {
        didSet {
            topTitleLabel.text = "创建钱包第一步的标题".toMultilingualism()
        }
    }
    
    @IBOutlet weak var subDesLabel: UILabel! {
        didSet {
            subDesLabel.text = "创建钱包第一步的子标题".toMultilingualism()
        }
    }
    
    private let selected1Control = UIControl()
    private let control1Subject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    @IBOutlet weak var selectedStack1: UIStackView! {
        didSet {
            selectedStack1.layer.cornerRadius = 3
            selectedStack1.layer.borderWidth = 1
            selectedStack1.layer.borderColor = ColorConfiguration.blackText.toColor().withAlphaComponent(0.3).cgColor
            selectedStack1.isLayoutMarginsRelativeArrangement = true
            selectedStack1.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            
            selected1Control.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 60)
            selectedStack1.addSubview(selected1Control)
            selected1Control.tag = 1
            selected1Control.addTarget(self, action: #selector(CreateWalletStepOneController.buttonTap(sender:)), for: .touchUpInside)
        }
    }
    
    private let selected2Control = UIControl()
    private let control2Subject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    @IBOutlet weak var selectedStack2: UIStackView! {
        didSet {
            selectedStack2.layer.cornerRadius = 3
            selectedStack2.layer.borderWidth = 1
            selectedStack2.layer.borderColor = ColorConfiguration.blackText.toColor().withAlphaComponent(0.3).cgColor
            selectedStack2.isLayoutMarginsRelativeArrangement = true
            selectedStack2.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            
            selected2Control.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 60)
            selectedStack2.addSubview(selected2Control)
            selected2Control.tag = 2
            selected2Control.addTarget(self, action: #selector(CreateWalletStepOneController.buttonTap(sender:)), for: .touchUpInside)
        }
    }
    
    private let selected3Control = UIControl()
    private let control3Subject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    @IBOutlet weak var selectedStack3: UIStackView! {
        didSet {
            selectedStack3.layer.cornerRadius = 3
            selectedStack3.layer.borderWidth = 1
            selectedStack3.layer.borderColor = ColorConfiguration.blackText.toColor().withAlphaComponent(0.3).cgColor
            selectedStack3.isLayoutMarginsRelativeArrangement = true
            selectedStack3.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            
            selected3Control.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 60)
            selectedStack3.addSubview(selected3Control)
            selected3Control.tag = 3
            selected3Control.addTarget(self, action: #selector(CreateWalletStepOneController.buttonTap(sender:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var selectedImage1: UIImageView!
    
    @IBOutlet weak var selectedLabel1: UILabel! {
        didSet {
            selectedLabel1.text = "创建钱包第一步按钮1".toMultilingualism()
        }
    }
    
    @IBOutlet weak var selectedImage2: UIImageView!
    
    @IBOutlet weak var selectedLabel2: UILabel! {
        didSet {
            selectedLabel2.text = "创建钱包第一步按钮2".toMultilingualism()
        }
    }
    
    @IBOutlet weak var selectedImage3: UIImageView!
    
    @IBOutlet weak var selectedLabel3: UILabel! {
        didSet {
            selectedLabel3.text = "创建钱包第一步按钮3".toMultilingualism()
        }
    }
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setupAPPUISolidStyle(title: "继续".toMultilingualism())
        }
    }

    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        nextButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc: CreateWalletStepTwoController = ViewLoader.Storyboard.controller(from: "Wallet")
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        
        Observable.combineLatest(control3Subject, control3Subject, control3Subject).map { tuple in
            return tuple.0 && tuple.0 && tuple.0
        }.subscribe(onNext: {[weak self] isEnabled in
            self?.nextButton.isEnabled = isEnabled
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "助记词".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }
    
    @objc
    private func buttonTap(sender: UIControl) {
        switch sender.tag {
        case 1:
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                selectedImage1.image = UIImage(named: "guarantee_check_box2")
            } else {
                selectedImage1.image = UIImage(named: "guarantee_check_box1")
            }
            control1Subject.onNext(sender.isSelected)
        case 2:
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                selectedImage2.image = UIImage(named: "guarantee_check_box2")
            } else {
                selectedImage2.image = UIImage(named: "guarantee_check_box1")
            }
            control2Subject.onNext(sender.isSelected)
        case 3:
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                selectedImage3.image = UIImage(named: "guarantee_check_box2")
            } else {
                selectedImage3.image = UIImage(named: "guarantee_check_box1")
            }
            control3Subject.onNext(sender.isSelected)
        default:
            break
        }
    }
}
