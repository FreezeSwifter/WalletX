//
//  StartGuaranteeConfirmController.swift
//  WalletX
//
//  Created by DZSB-001968 on 24.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx


class StartGuaranteeConfirmController: UIViewController, HomeNavigationble {
    
    @IBOutlet weak var topNotiBg: UIStackView! {
        didSet {
            topNotiBg.layer.cornerRadius = 10
            topNotiBg.isLayoutMarginsRelativeArrangement = true
            topNotiBg.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    @IBOutlet weak var topNotiLabel: UILabel! {
        didSet {
            topNotiLabel.text = "多签第二部提示说明".toMultilingualism()
        }
    }
    
    @IBOutlet weak var feeBg: UIView!
    @IBOutlet weak var feeTextField: UITextField! {
        didSet {
            feeTextField.placeholder = "请输入手续费".toMultilingualism()
        }
    }
    
    @IBOutlet weak var feeDesLabel: UILabel! {
        didSet {
            feeDesLabel.text = "手续费".toMultilingualism()
        }
    }
    
    @IBOutlet weak var waringBg: UIStackView! {
        didSet {
            waringBg.layer.cornerRadius = 10
            waringBg.isLayoutMarginsRelativeArrangement = true
            waringBg.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    @IBOutlet weak var waringLabel: UILabel! {
        didSet {
            waringLabel.text = "转账凭证说明".toMultilingualism()
        }
    }
    
    @IBOutlet weak var rqCodeDesContentLabel: UILabel! {
        didSet {
            rqCodeDesContentLabel.text = "扫码说明".toMultilingualism()
            rqCodeDesContentLabel.textColor = ColorConfiguration.descriptionText.toColor()
        }
    }
    
    @IBOutlet weak var rqCodeImage: UIImageView! {
        didSet {
            Task {
                let img = await ScanViewController.generateQRCode(text: "测试数据", size: 172)
                DispatchQueue.main.async {
                    self.rqCodeImage.image = img
                }
            }
        }
    }
    
    @IBOutlet weak var qrCodeDesLabel: UILabel! {
        didSet {
            qrCodeDesLabel.text = "二维码".toMultilingualism()
        }
    }
    
    @IBOutlet weak var addressCopyButton: UIButton! {
        didSet {
            addressCopyButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var addressTextField: UITextField! {
        didSet {
            addressTextField.placeholder = "请输入收款地址".toMultilingualism()
        }
    }
    
    @IBOutlet weak var addressDesLabel: UILabel! {
        didSet {
            addressDesLabel.text = "收款地址".toMultilingualism()
        }
    }
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.setTitle("share_Share".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var downloadButton: UIButton! {
        didSet {
            downloadButton.setTitle("share_Download".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.backgroundColor = ColorConfiguration.primary.toColor()
            doneButton.setTitle("已付手续费".toMultilingualism(), for: .normal)
            doneButton.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        
        doneButton.rx.tap.subscribe(onNext: {[unowned self] in
            
            GuaranteeYesNoView.showFromBottom(image: UIImage(named: "guarantee_yes_no"), title: "发起担保确认转账标题".toMultilingualism(), titleIcon: UIImage(named: "guarantee_bulb"), content: "发起担保确认转账内容".toMultilingualism(), leftButton: "未完成".toMultilingualism(), rightButton: "已完成".toMultilingualism()).subscribe(onNext: { index in
                if index == 1 {
                    let vc: InviteGuaranteeController = ViewLoader.Storyboard.controller(from: "Guarantee")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
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
    }
}
