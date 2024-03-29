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
            moneyDewLabel.text = "担保金额没有1".toMultilingualism()
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
            downButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            downButton.setTitle("share_Download".toMultilingualism(), for: .normal)
            downButton.layer.borderWidth = 1
            downButton.layer.cornerRadius = 15
            downButton.clipsToBounds = true
            downButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
            downButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        }
    }
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            shareButton.setTitle("share_Share".toMultilingualism(), for: .normal)
            shareButton.layer.borderWidth = 1
            shareButton.layer.cornerRadius = 15
            shareButton.clipsToBounds = true
            shareButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
            shareButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
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
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: {[weak self] in
            let app = UIApplication.shared.delegate as? AppDelegate
            app?.tabBarSelecte(index: 3)
            self?.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    
        downButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.captureScreenshot()
        }).disposed(by: rx.disposeBag)
        
        shareButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0.0)
            self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            guard let screenshotImage = UIGraphicsGetImageFromCurrentImageContext() else {
                return
            }
            UIGraphicsEndImageContext()
            
            self.shareImageToTelegram(image: screenshotImage)
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
    
    private func shareImageToTelegram(image: UIImage) {
        let activityItems: [Any] = [image]
        
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if completed {
                print("Image shared successfully")
            }
        }
        
        // Exclude all activities except Telegram
        activityController.excludedActivityTypes = []
        if let popoverPresentationController = activityController.popoverPresentationController {
            popoverPresentationController.sourceView = UIApplication.topViewController()?.view
            popoverPresentationController.sourceRect = CGRect(x: 0, y: 0, width: 1, height: 1)
            popoverPresentationController.permittedArrowDirections = []
        }
        
        UIApplication.topViewController()?.present(activityController, animated: true, completion: nil)
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
    }
}
