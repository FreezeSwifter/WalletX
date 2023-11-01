//
//  InviteGuaranteeController.swift
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


class InviteGuaranteeController: UIViewController, HomeNavigationble {

    @IBOutlet weak var notiBg: UIStackView! {
        didSet {
            notiBg.isLayoutMarginsRelativeArrangement = true
            notiBg.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    @IBOutlet weak var notiLabel: UILabel! {
        didSet {
            notiLabel.text = "邀请对方加入小喇叭".toMultilingualism()
        }
    }
    
    @IBOutlet weak var moneyDewLabel: UILabel! {
        didSet {
            moneyDewLabel.text = "home_amount".toMultilingualism()
        }
    }
    
    @IBOutlet weak var moneyTextField: UITextField! {
        didSet {
            moneyTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var idDesLabel: UILabel! {
        didSet {
            idDesLabel.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var idTextField: UITextField! {
        didSet {
            idTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var copyButton: UIButton! {
        didSet {
            copyButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var rqDesLabel: UILabel! {
        didSet {
            rqDesLabel.text = "二维码".toMultilingualism()
        }
    }
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    @IBOutlet weak var downButton: UIButton! {
        didSet {
            downButton.setTitle("share_Download".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.setTitle("完成".toMultilingualism(), for: .normal)
            doneButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            doneButton.layer.cornerRadius = 4
            doneButton.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }
    
    var model: GuaranteeInfoModel.Meta?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }
    
    private func bind() {
        moneyTextField.text = "\(model?.amount ?? 0)"
        idTextField.text = "\(model?.assureId ?? "--")"
        if let id = model?.assureId {
            Task {
                let img = await ScanViewController.generateQRCode(text: id, size: 141)
                qrImageView.image = img
            }
        }
        
        copyButton.rx.tap.subscribe(onNext: {[weak self] in
            UIPasteboard.general.string = self?.model?.assureId
        }).disposed(by: rx.disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    
        downButton.rx.tap.subscribe(onNext: {[weak self] _ in
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
        headerView?.titleLabel.text = "邀请对方加入".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }
}
