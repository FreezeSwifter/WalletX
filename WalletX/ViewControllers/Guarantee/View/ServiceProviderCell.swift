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

class ServiceProviderCell: UICollectionViewCell {

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
        }
    }
    
    @IBOutlet weak var collectButton: UIButton! {
        didSet {
            collectButton.backgroundColor = ColorConfiguration.grayBg.toColor()
            collectButton.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: .normal)
            collectButton.setTitleColor(ColorConfiguration.blackText.toColor(), for: .selected)
            collectButton.applyCornerRadius(7)
            collectButton.setTitle("home_RMB".toMultilingualism(), for: UIControl.State())
        }
    }
    
    @IBOutlet weak var moreButton: UIButton! {
        didSet {
            moreButton.backgroundColor = ColorConfiguration.grayBg.toColor()
            moreButton.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: .normal)
            moreButton.setTitleColor(ColorConfiguration.blackText.toColor(), for: .selected)
            moreButton.applyCornerRadius(7)
            moreButton.setTitle("home_more".toMultilingualism(), for: UIControl.State())
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
        
        ["东野圭吾", "三体", "爱", "红楼梦", "理智与情感", "读书热榜", "免费榜"].forEach { str in
            let btn = QMUIButton(type: .custom)
            btn.backgroundColor = ColorConfiguration.homeItemBg.toColor()
            btn.setImage(UIImage(named: "tabbar_gurantee_item"), for: UIControl.State())
            btn.imagePosition = .left
            btn.spacingBetweenImageAndTitle = 4
            btn.setTitle(str, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            btn.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: .normal)
            btn.titleLabel?.minimumScaleFactor = 0.8
            btn.applyCornerRadius(7)
            layoutView.addSubview(btn)
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
