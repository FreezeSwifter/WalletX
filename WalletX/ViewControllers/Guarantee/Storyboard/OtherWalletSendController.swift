//
//  OtherWalletSendController.swift
//  WalletX
//
//  Created by DZSB-001968 on 9.12.23.
//

import UIKit
import RxSwift
import RxCocoa

extension OtherWalletSendController {
    enum PayType {
        case fee
        case deposited(isInitiator: Bool)
    }
}


class OtherWalletSendController: UIViewController, HomeNavigationble {
    
    var payType: PayType = .fee
    
    var model: GuaranteeInfoModel.Meta?
    
    var networkModel: GuaranteeInfoModel? {
        didSet {
            updateValue()
        }
    }
    
    @IBOutlet weak var transferAmountLabel: UILabel! {
        didSet {
            transferAmountLabel.text = "转账金额".toMultilingualism()
        }
    }
    
    @IBOutlet weak var transferAmountValue: UITextField! {
        didSet {
            transferAmountValue.placeholder = nil
            transferAmountValue.isEnabled = false
        }
    }
    
    @IBOutlet weak var tipLabel: UILabel! {
        didSet {
            tipLabel.text = nil
        }
    }
    
    @IBOutlet weak var acceptLabel: UILabel! {
        didSet {
            acceptLabel.text = "收款地址".toMultilingualism()
        }
    }
    
    @IBOutlet weak var acceptValue: UITextField! {
        didSet {
            acceptValue.placeholder = nil
            acceptValue.isEnabled = false
            acceptValue.adjustsFontSizeToFitWidth = true
            acceptValue.minimumFontSize = 0.7
        }
    }
    
    @IBOutlet weak var qrCodeLabel: UILabel! {
        didSet {
            qrCodeLabel.text = "二维码".toMultilingualism()
        }
    }
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            shareButton.setTitle("share_Share".toMultilingualism(), for: .normal)
            shareButton.layer.borderWidth = 1
            shareButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
            shareButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        }
    }
    
    @IBOutlet weak var downloadButton: UIButton! {
        didSet {
            downloadButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            downloadButton.setTitle("share_Download".toMultilingualism(), for: .normal)
            downloadButton.layer.borderWidth = 1
            downloadButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
            downloadButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        }
    }
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.setupAPPUISolidStyle(title: "我已完成转账".toMultilingualism())
        }
    }
    
    @IBOutlet weak var tipStackView: UIStackView! {
        didSet {
            tipStackView.layer.cornerRadius = 10
            tipStackView.isLayoutMarginsRelativeArrangement = true
            tipStackView.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        }
    }
    
    @IBOutlet weak var copyButton: UIButton! {
        didSet {
            copyButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
            copyButton.titleLabel?.adjustsFontSizeToFitWidth = true
            copyButton.titleLabel?.minimumScaleFactor = 0.5
        }
    }
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.backgroundColor = .white
        headerView?.titleLabel.text = "其他钱包转入".toMultilingualism()
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        view.backgroundColor = .white
        fetchData()
        
        copyButton.rx.tap.subscribe(onNext: {[weak self] in
            UIPasteboard.general.string = self?.networkModel?.data?.hcAddr
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
        
        downloadButton.rx.tap.subscribe(onNext: {[weak self] _ in
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
        
        doneButton.rx.tap.subscribe(onNext: {[unowned self] in
            doneButtonTap()
        }).disposed(by: rx.disposeBag)
        
    }
    
    private func doneButtonTap() {
        GuaranteeYesNoView.showFromBottom(image: UIImage(named: "guarantee_yes_no"), title: "您确认已经完成转账了吗".toMultilingualism(), titleIcon: UIImage(named: "guarantee_bulb"), content: "您确认已经完成转账了吗内容".toMultilingualism(), leftButton: "未完成".toMultilingualism(), rightButton: "已完成".toMultilingualism()).subscribe(onNext: {[weak self] index in
            if index == 1 {
                guard let id = self?.model?.assureId, let this = self else { return }
                APIProvider.rx.request(.finiedOrder(assureId: id)).mapJSON().subscribe().disposed(by: this.rx.disposeBag)
                this.navigationController?.popToRootViewController(animated: true)
            }
        }).disposed(by: self.rx.disposeBag)
    }
    
    private func updateValue() {
        switch payType {
        case .fee:
            let code = networkModel?.data?.hc?.components(separatedBy: ".").last
            tipLabel.text = "\("转账验证码".toMultilingualism()): \(code ?? "--")\n\("其他钱包转入提示语".toMultilingualism())"
            transferAmountValue.text = "\(networkModel?.data?.hc ?? "")"
            acceptValue.text = networkModel?.data?.hcAddr ?? "--"
            
            Task {
                let img = await ScanViewController.generateQRCode(text: networkModel?.data?.hcAddr ?? "", size: qrImageView.width)
                qrImageView.image = img
            }
            
        case .deposited(let isInitiator):
            var pushWaitAmount = "\(model?.pushWaitAmount ?? 0)".decimalPlaces(decimal: 0) ?? ""
            
            if isInitiator {
                let pushDecimalSponsor = model?.pushDecimalSponsor ?? ""
                pushWaitAmount += "."
                pushWaitAmount += pushDecimalSponsor
                tipLabel.text = "\("转账验证码".toMultilingualism()): \(pushDecimalSponsor)\n\("其他钱包转入提示语".toMultilingualism())"
                
            } else {
                let pushDecimalPartner = model?.pushDecimalPartner ?? ""
                pushWaitAmount += "."
                pushWaitAmount += pushDecimalPartner
                tipLabel.text = "\("转账验证码".toMultilingualism()): \(pushDecimalPartner)\n\("其他钱包转入提示语".toMultilingualism())"
            }
            transferAmountValue.text = pushWaitAmount
            acceptValue.text = model?.pushAddr
            
            Task {
                let img = await ScanViewController.generateQRCode(text: model?.pushAddr ?? "", size: qrImageView.width)
                qrImageView.image = img
            }
        }
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
    
    private func fetchData() {
        let req: Observable<GuaranteeInfoModel?> = APIProvider.rx.request(.getAssureOrderDetail(assureId: model?.assureId ?? "")).mapModel()
        req.subscribe(onNext: {[weak self] obj in
            self?.networkModel = obj
        }).disposed(by: rx.disposeBag)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("保存到相册出错: \(error.localizedDescription)")
        } else {
            APPHUD.flash(text: "成功".toMultilingualism())
            print("成功保存到相册")
        }
    }
}
