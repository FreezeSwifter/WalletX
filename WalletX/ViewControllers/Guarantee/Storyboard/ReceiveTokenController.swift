//
//  ReceiveTokenController.swift
//  WalletX
//
//  Created by DZSB-001968 on 31.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx
import Photos


class ReceiveTokenController: UIViewController, HomeNavigationble {
    
    var model: WalletToken?
    
    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.layer.masksToBounds = false
            bgView.layer.shadowColor = ColorConfiguration.primary.toColor().withAlphaComponent(0.4).cgColor
            bgView.layer.shadowOpacity = 0.8
            bgView.layer.shadowOffset = CGSize(width: -1, height: 1)
            bgView.layer.shadowRadius = 10
            bgView.layer.shadowPath = UIBezierPath(rect: bgView.bounds).cgPath
            bgView.layer.shouldRasterize = true
            bgView.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    @IBOutlet weak var notiBg: UIView! {
        didSet {
            notiBg.applyCornerRadius(7)
        }
    }
    
    @IBOutlet weak var notiIconImageView: UIImageView! {
        didSet {
            let img = UIImage(named: "wallet_noti2")?.qmui_image(withTintColor: UIColor(hex: "F0A158"))
            notiIconImageView.image = img
        }
    }
    
    @IBOutlet weak var notiLabel: UILabel! {
        didSet {
            notiLabel.text = "接收Token警告".toMultilingualism()
        }
    }
    
    @IBOutlet weak var button1: QMUIButton! {
        didSet {
            button1.setImage(UIImage(named: "wallet_paste"), for: .normal)
            button1.setBackgroundColor(color: ColorConfiguration.primary.toColor(), forState: .normal)
            button1.clipsToBounds = true
            button1.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var button2: QMUIButton! {
        didSet {
            button2.setImage(UIImage(named: "wallet_download"), for: .normal)
            button2.setBackgroundColor(color: ColorConfiguration.primary.toColor(), forState: .normal)
            button2.clipsToBounds = true
            button2.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var button1Label: UILabel! {
        didSet {
            button1Label.text = "复制地址".toMultilingualism()
        }
    }
    
    @IBOutlet weak var button2Label: UILabel! {
        didSet {
            button2Label.text = "下载".toMultilingualism()
        }
    }
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        guard let address = model?.address else { return }
        addressLabel.text = address
        
        Task {
            let image = await ScanViewController.generateQRCode(text: address, size: 700)
            qrImageView.image = image
        }
        
        button2.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let this = self, let _ = this.qrImageView.image else { return }
            this.saveScreenshotToAlbum()
        }).disposed(by: rx.disposeBag)
        
        button1.rx.tap.subscribe(onNext: { _ in
            UIPasteboard.general.string = address
            APPHUD.flash(text: "完成".toMultilingualism())
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = model?.tokenName
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }
    
    private func saveImageToAlbum(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if success {
                print("图片保存成功")
            } else {
                print("图片保存失败: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    func saveScreenshotToAlbum() {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.layer.render(in: context)
        guard let screenshot = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        UIGraphicsEndImageContext()

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: screenshot)
        }) { (success, error) in
            if success {
                print("截图保存成功")
            } else {
                print("截图保存失败: \(error?.localizedDescription ?? "")")
            }
        }
    }
}
