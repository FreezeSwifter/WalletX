//
//  ShareViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 23.8.23.
//

import UIKit
import QMUIKit



class ShareViewController: UIViewController, HomeNavigationble {
    
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer.init(target: self, action: #selector(ShareViewController.logoTap))
            logoImageView.addGestureRecognizer(gesture)
        }
    }
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    @IBOutlet weak var downloadButton: UIButton! {
        didSet {
            downloadButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            downloadButton.setTitle("share_Download".toMultilingualism(), for: .normal)
            downloadButton.layer.borderWidth = 1
            downloadButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
        }
    }
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            shareButton.setTitle("share_Share".toMultilingualism(), for: .normal)
            shareButton.layer.borderWidth = 1
            shareButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
        }
    }
    
    @IBOutlet weak var linkDesLabel: UILabel! {
        didSet {
            linkDesLabel.textColor = ColorConfiguration.blackText.toColor()
            linkDesLabel.text = "share_Link".toMultilingualism()
        }
    }
    
    @IBOutlet weak var linkLabel: UILabel! {
        didSet {
            linkLabel.textColor = ColorConfiguration.blackText.toColor()
            
            let text = "ask292j31827391h9"
            let textRange = NSRange(location: 0, length: text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: textRange)
            linkLabel.attributedText = attributedText
        }
    }
    
    @IBOutlet weak var copyButton: UIButton! {
        didSet {
            copyButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            copyButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        Task {
            let image = await ScanViewController.generateQRCode(text: "测试数据", size: 182)
            DispatchQueue.main.async {
                self.qrCodeImageView.image = image
            }
        }
        
        copyButton.rx.tap.subscribe(onNext: {[weak self] _ in
            UIPasteboard.general.string = self?.linkLabel.text
            APPHUD.flash(text: "copy successful".toMultilingualism())
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = ColorConfiguration.shareBg.toColor()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "share_friend".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        shareButton.snp.remakeConstraints { make in
            make.width.equalTo(shareButton.bounds.size.width + 32)
            make.height.equalTo(40)
        }
        shareButton.layer.cornerRadius = shareButton.height / 2
        shareButton.centerTextAndImage(spacing: 8)
        
        downloadButton.snp.remakeConstraints { make in
            make.width.equalTo(downloadButton.bounds.size.width + 32)
            make.height.equalTo(40)
        }
        downloadButton.layer.cornerRadius = shareButton.height / 2
        downloadButton.centerTextAndImage(spacing: 8)
    }
    
    @objc
    private func logoTap() {
        
        NotiAlterView.show(title: "如何领取推荐奖励？", content: "分享二维码或链接给您的好友；\n获知您好友注册之后的钱包地址；\n联系客服凭好友的钱包地址申领；\n客服核实是真实注册后发放奖励。", leftButtonTitle: "联系客服", rightButtonTitle: "我知道了").subscribe(onNext: { index in
            
        }).disposed(by: rx.disposeBag)
    }
}
