//
//  serviceProviderCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 14.8.23.
//

import UIKit
import QMUIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import Kingfisher

class ServiceProviderCell: UICollectionViewCell {
    
    var datasource: [ServiceListModel] = [] {
        didSet {
            reloadLayoutView()
        }
    }
    
    @IBOutlet weak var topLabel: UILabel! {
        didSet {
            topLabel.textColor = ColorConfiguration.blodText.toColor()
            topLabel.text = "home_topService".toMultilingualism()
        }
    }
    
    @IBOutlet weak var changeButton: UIButton! {
        didSet {
            changeButton.backgroundColor = ColorConfiguration.grayBg.toColor()
            changeButton.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: .normal)
            changeButton.setTitleColor(ColorConfiguration.blackText.toColor(), for: .selected)
            changeButton.applyCornerRadius(7)
            changeButton.setTitle("home_USDT".toMultilingualism(), for: UIControl.State())
            changeButton.isSelected = true
            changeButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
            changeButton.titleLabel?.minimumScaleFactor = 0.5
            changeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var collectButton: UIButton! {
        didSet {
            collectButton.backgroundColor = ColorConfiguration.grayBg.toColor()
            collectButton.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: .normal)
            collectButton.setTitleColor(ColorConfiguration.blackText.toColor(), for: .selected)
            collectButton.applyCornerRadius(7)
            collectButton.setTitle("home_RMB".toMultilingualism(), for: UIControl.State())
            collectButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
            collectButton.titleLabel?.minimumScaleFactor = 0.5
            collectButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var moreButton: UIButton! {
        didSet {
            moreButton.backgroundColor = ColorConfiguration.grayBg.toColor()
            moreButton.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: .normal)
            moreButton.setTitleColor(ColorConfiguration.blackText.toColor(), for: .selected)
            moreButton.applyCornerRadius(7)
            moreButton.setTitle("home_more".toMultilingualism(), for: UIControl.State())
            moreButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
            moreButton.titleLabel?.minimumScaleFactor = 0.5
            moreButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    lazy var layoutView: QMUIFloatLayoutView = {
        let v = QMUIFloatLayoutView.init(frame: .zero)
        v.itemMargins = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        v.minimumItemSize = CGSize(width: (UIScreen.main.bounds.size.width - 60) / 3, height: 40)
        return v
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(layoutView)
        layoutView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(30)
            make.trailing.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    private func reloadLayoutView() {
        layoutView.subviews.forEach { $0.removeFromSuperview() }
        datasource.enumerated().forEach { (index, item) in
            let btn = QMUIButton(type: .custom)
            btn.backgroundColor = ColorConfiguration.homeItemBg.toColor()
            if let logo = item.logo, let logoUrl = URL(string: logo) {
                btn.kf.setImage(with: logoUrl, for: .normal)
            }
            btn.imagePosition = .left
            btn.spacingBetweenImageAndTitle = 4
            btn.setTitle(item.mertName, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            btn.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: .normal)
            btn.titleLabel?.minimumScaleFactor = 0.5
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.applyCornerRadius(7)
            btn.tag = index + 1
            btn.addTarget(self, action: #selector(ServiceProviderCell.openTg(sender:)), for: .touchUpInside)
            layoutView.addSubview(btn)
            
        }
    }
    
    @objc
    private func openTg(sender: QMUIButton) {
        let id = datasource[sender.tag - 1].tg ?? ""
        let appURL = URL(string: "telegram://")!
        if UIApplication.shared.canOpenURL(appURL) {
            let appUrl = URL(string: "tg://resolve?domain=\(id)")
            if let url = appUrl {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                APPHUD.flash(text: "Error")
            }
        } else {
            APPHUD.flash(text: "Not Install Telegram")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        NotificationCenter.default.rx.notification(.languageChanged).observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            self?.topLabel.text = "home_topService".toMultilingualism()
            self?.changeButton.setTitle("home_USDT".toMultilingualism(), for: UIControl.State())
            self?.collectButton.setTitle("home_RMB".toMultilingualism(), for: UIControl.State())
            self?.moreButton.setTitle("home_more".toMultilingualism(), for: UIControl.State())
        }).disposed(by: rx.disposeBag)
    }
    
}
