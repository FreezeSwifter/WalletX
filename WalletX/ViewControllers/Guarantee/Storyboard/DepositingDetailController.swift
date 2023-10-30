//
//  DepositingDetailController.swift
//  WalletX
//
//  Created by DZSB-001968 on 29.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx


class DepositingDetailController: UIViewController {

    var model: GuaranteeInfoModel.Meta? {
        didSet {
            updateVlaue()
        }
    }
    
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.text = "发起时间".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel3: UILabel! {
        didSet {
            desLabel3.text = "担保金额没有1".toMultilingualism()
        }
    }

    @IBOutlet weak var desLabel4: UILabel! {
        didSet {
            desLabel4.text = "发起人".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel4Me: UILabel! {
        didSet {
            desLabel4Me.text = "我".toMultilingualism()
            desLabel4Me.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            desLabel4Me.minimumScaleFactor = 0.5
            desLabel4Me.adjustsFontSizeToFitWidth = true
            desLabel4Me.isHidden = true
            desLabel4Me.textAlignment = .center
        }
    }
    
    @IBOutlet weak var desLabel5Me: UILabel! {
        didSet {
            desLabel5Me.text = "我".toMultilingualism()
            desLabel5Me.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            desLabel5Me.minimumScaleFactor = 0.5
            desLabel5Me.adjustsFontSizeToFitWidth = true
            desLabel5Me.isHidden = true
            desLabel5Me.textAlignment = .center
        }
    }
    
    @IBOutlet weak var desLabel5: UILabel! {
        didSet {
            desLabel5.text = "参与人".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel1Status: UILabel! {
        didSet {
            valueLabel1Status.minimumScaleFactor = 0.5
            valueLabel1Status.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var desLabel8: UILabel! {
        didSet {
            desLabel8.text = "6位小数".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel1: UILabel! {
        didSet {
            valueLabel1.minimumScaleFactor = 0.5
            valueLabel1.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel1Protocol: UILabel! {
        didSet {
            valueLabel1Protocol.text = "协议".toMultilingualism()
            valueLabel1Protocol.minimumScaleFactor = 0.5
            valueLabel1Protocol.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel2: UILabel! {
        didSet {
            valueLabel2.minimumScaleFactor = 0.5
            valueLabel2.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel3: UILabel! {
        didSet {
            valueLabel3.minimumScaleFactor = 0.5
            valueLabel3.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel4: UILabel! {
        didSet {
            valueLabel4.minimumScaleFactor = 0.5
            valueLabel4.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel5: UILabel! {
        didSet {
            valueLabel5.minimumScaleFactor = 0.5
            valueLabel5.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var notiBg: UIView! {
        didSet {
            notiBg.clipsToBounds = true
            notiBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var notiLabel: UILabel! {
        didSet {
            notiLabel.text = "上押小喇叭提示".toMultilingualism()
        }
    }
    
    @IBOutlet weak var explainButton: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel! {
        didSet {
            addressLabel.text = "钱包地址".toMultilingualism()
        }
    }
    
    @IBOutlet weak var addrtessField: UITextField! {
        didSet {
            addrtessField.placeholder = nil
            addrtessField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var addressCopyButton: UIButton! {
        didSet {
            addressCopyButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
            addressCopyButton.titleLabel?.adjustsFontSizeToFitWidth = true
            addressCopyButton.titleLabel?.minimumScaleFactor = 0.5
        }
    }
    
    @IBOutlet weak var qeDesLabel: UILabel! {
        didSet {
            qeDesLabel.text = "二维码".toMultilingualism()
        }
    }
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    @IBOutlet weak var downloadButton: UIButton! {
        didSet {
            downloadButton.setTitle("share_Download".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var bottomLeftButton: UIButton! {
        didSet {
            bottomLeftButton.setTitle("站内钱包导入".toMultilingualism(), for: .normal)
            bottomLeftButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            bottomLeftButton.layer.cornerRadius = 10
            bottomLeftButton.backgroundColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    @IBOutlet weak var bottomRIghtButton: UIButton! {
        didSet {
            bottomRIghtButton.setTitle("我已完成上押".toMultilingualism(), for: .normal)
            bottomRIghtButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            bottomRIghtButton.layer.cornerRadius = 10
            bottomRIghtButton.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }
    
    @IBOutlet weak var protocolBg: UIStackView! {
        didSet {
            protocolBg.isLayoutMarginsRelativeArrangement = true
            protocolBg.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            protocolBg.applyCornerRadius(protocolBg.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
            let ges = UITapGestureRecognizer(target: self, action: #selector(DepositingDetailController.protocolTap))
            protocolBg.addGestureRecognizer(ges)
        }
    }
    
    
    @IBOutlet weak var desLabel6: UILabel! {
        didSet {
            desLabel6.text = "已上押".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel7: UILabel! {
        didSet {
            desLabel7.text = "me_depositing".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel6: UILabel! {
        didSet {
            valueLabel6.minimumScaleFactor = 0.5
            valueLabel6.adjustsFontSizeToFitWidth = true
        }
    }
  
    @IBOutlet weak var valueLabel7: UILabel! {
        didSet {
            valueLabel7.minimumScaleFactor = 0.5
            valueLabel7.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel8: UILabel! {
        didSet {
            valueLabel8.minimumScaleFactor = 0.5
            valueLabel8.adjustsFontSizeToFitWidth = true
            valueLabel8.text = "--"
            valueLabel8.textColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func updateVlaue() {
        view.layoutIfNeeded()
        valueLabel1.text = model?.assureId ?? "--"
        valueLabel2.text = Date(timeIntervalSince1970: (model?.createTime ?? 0) / 1000 ).toFormat("yyyy-MM-dd HH:mm:ss")
        let amount = NSMutableAttributedString(string: "\(model?.amount ?? 0) USDT")
        valueLabel3.textColor = ColorConfiguration.lightBlue.toColor()
        amount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
        valueLabel3.attributedText = amount
        
        let custodyAmount = NSMutableAttributedString(string: "\(model?.custodyAmount ?? 0) USDT")
        valueLabel6.textColor = ColorConfiguration.primary.toColor()
        custodyAmount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
        valueLabel6.attributedText = custodyAmount
        
        let pushAmount = NSMutableAttributedString(string: "\(model?.pushAmount ?? 0) USDT")
        valueLabel7.textColor = ColorConfiguration.primary.toColor()
        pushAmount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
        valueLabel7.attributedText = pushAmount
        
        valueLabel4.text = model?.sponsorUserName ?? "--"
        valueLabel5.text = model?.partnerUserName ?? "--"
        
        if model?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
            desLabel4Me.isHidden = false
            desLabel5Me.isHidden = true
            valueLabel8.text = model?.pushDecimalSponsor
        } else {
            desLabel4Me.isHidden = true
            desLabel5Me.isHidden = false
            valueLabel8.text = model?.pushDecimalPartner
        }
        
        if model?.assureType == 0 { // 普通担保
            addrtessField.text = model?.pushAddress
            Task {
                let img = await ScanViewController.generateQRCode(text: model?.pushAddress ?? "", size: 141)
                qrImageView.image = img
            }
        } else { // 多签担保
            addrtessField.text = model?.multisigAddress
            Task {
                let img = await ScanViewController.generateQRCode(text: model?.multisigAddress ?? "", size: 141)
                qrImageView.image = img
            }
        }
    }
    
    private func bind() {
        
        let req: Observable<GuaranteeInfoModel?> = APIProvider.rx.request(.getAssureOrderDetail(assureId: model?.assureId ?? "")).mapModel()
        req.subscribe(onNext: {[weak self] obj in
            self?.model = obj?.data
        }).disposed(by: rx.disposeBag)
     
        explainButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            
            NotiAlterView.show(title: "什么是2-3钱包".toMultilingualism(), content: "什么是2-3钱包内容".toMultilingualism(), leftButtonTitle: "联系客服".toMultilingualism(), rightButtonTitle: "我知道啦".toMultilingualism()).subscribe(onNext: { _ in
                
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        bottomRIghtButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            
            GuaranteeYesNoView.showFromBottom(image: UIImage(named: "guarantee_yes_no"), title: "您已经完成押金上传了吗".toMultilingualism(), titleIcon: UIImage(named: "guarantee_bulb"), content: "您已经完成押金上传了吗内容".toMultilingualism(), leftButton: "未完成".toMultilingualism(), rightButton: "已完成".toMultilingualism()).subscribe(onNext: {[weak self] index in
                
                if index == 1 {
                    guard let id = self?.model?.assureId, let this = self else { return }
                    APIProvider.rx.request(.finiedOrder(assureId: id)).mapJSON().subscribe().disposed(by: this.rx.disposeBag)
                    this.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        bottomLeftButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc: DepositViewController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.currentItem = self?.model
            self?.navigationController?.pushViewController(vc, animated: true)
            
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
            print("成功保存到相册")
        }
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        title = "上传押金".toMultilingualism()
        view.layoutIfNeeded()
        
        desLabel4Me.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        desLabel5Me.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        desLabel4Me.applyCornerRadius(10)
        desLabel5Me.applyCornerRadius(10)
    }
    
    @objc
    private func protocolTap() {
        NotiAlterView.show(title: "协议".toMultilingualism(), content: model?.agreement, leftButtonTitle: nil, rightButtonTitle: "我知道啦".toMultilingualism()).subscribe(onNext: { _ in
            
        }).disposed(by: rx.disposeBag)
    }
}
