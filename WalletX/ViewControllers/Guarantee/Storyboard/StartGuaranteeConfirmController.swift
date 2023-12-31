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
import HandyJSON


class StartGuaranteeConfirmController: UIViewController, HomeNavigationble {
    
    var parameter: StartGuaranteeController.Parameter?
    
    @IBOutlet weak var topPaddingOffset: NSLayoutConstraint!
    
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
            feeTextField.isUserInteractionEnabled = false
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
    
    @IBOutlet weak var rqCodeImage: UIImageView!
    
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
            addressTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var addressDesLabel: UILabel! {
        didSet {
            addressDesLabel.text = "收款地址".toMultilingualism()
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
    
    @IBOutlet weak var bottomBg: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        
        doneButton.rx.tap.subscribe(onNext: { _ in
            GuaranteeYesNoView.showFromBottom(image: UIImage(named: "guarantee_yes_no"), title: "发起担保确认转账标题".toMultilingualism(), titleIcon: UIImage(named: "guarantee_bulb"), content: "发起担保确认转账内容".toMultilingualism(), leftButton: "未完成".toMultilingualism(), rightButton: "已完成".toMultilingualism()).subscribe(onNext: {[weak self] index in
                if index == 1 {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        if parameter?.assureType == 0 { // 普通签
            feeBg.isHidden = true
            waringBg.isHidden = true
            topPaddingOffset.isActive = false
            bottomBg.snp.makeConstraints { make in
                make.top.equalTo(topNotiBg.snp.bottom).offset(20)
            }
            
        } else { // 多签
            
            APIProvider.rx.request(.getFeeforMultipleSignatures).mapDoubleValue().subscribe(onNext: {[weak self] value in
                guard let fee = value else { return }
                self?.feeTextField.text = fee.description
                self?.parameter?.hc = fee
                NotificationCenter.default.post(name: .orderDidChangeed, object: nil)
            }).disposed(by: rx.disposeBag)
        }
        
        let type = parameter?.assureType ?? 1
        APIProvider.rx.request(.getSignaturesAddress(type: type)).mapJSON().subscribe(onSuccess: {[weak self] obj in
            guard let dict = obj as? [String: Any], let data = dict["data"] as? [String: Any] else { return }
            
            let walletAddr = data["walletAddr"] as? String ?? ""
            if let qrCode = data["qrCode"] as? String {
                Task {
                    let img = await ScanViewController.generateQRCode(text: qrCode, size: 172)
                    self?.rqCodeImage.image = img
                }
            } else {
                Task {
                    let img = await ScanViewController.generateQRCode(text: walletAddr, size: 172)
                    self?.rqCodeImage.image = img
                }
            }
            self?.addressTextField.text = walletAddr
            self?.parameter?.hcAddr  = walletAddr
            
        }).disposed(by: rx.disposeBag)
        
        addressCopyButton.rx.tap.subscribe(onNext: {[weak self] in
            UIPasteboard.general.string = self?.addressTextField.text
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
        
        downloadButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.captureScreenshot()
        }).disposed(by: rx.disposeBag)
    }
    
    private func captureScreenshot() {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        guard let screenshotImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        UIGraphicsEndImageContext()

        // 保存截图到相册
        UIImageWriteToSavedPhotosAlbum(screenshotImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("保存到相册出错: \(error.localizedDescription)")
        } else {
            APPHUD.flash(text: "成功".toMultilingualism())
            print("成功保存到相册")
        }
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "home_newGuaranty".toMultilingualism()
        headerView?.backgroundColor = .white
      
    }
}
