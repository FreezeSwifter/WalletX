//
//  HomeQuickAccessCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 12.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx


class HomeQuickAccessCell: UICollectionViewCell {

    @IBOutlet weak var guranteeDesLabel: UILabel! {
        didSet {
            guranteeDesLabel.text = "home_orders".toMultilingualism()
            guranteeDesLabel.textColor = ColorConfiguration.descriptionText.toColor()
        }
    }
    
    @IBOutlet weak var guranteeValueLabel: UILabel! {
        didSet {
            guranteeValueLabel.textColor = ColorConfiguration.blodText.toColor()
            guranteeValueLabel.text = "--"
        }
    }
    
    @IBOutlet weak var marginDesLabel: UILabel! {
        didSet {
            marginDesLabel.text = "home_amount".toMultilingualism()
            marginDesLabel.textColor = ColorConfiguration.descriptionText.toColor()
        }
    }
    
    @IBOutlet weak var marginValueLabel: UILabel! {
        didSet {
            marginValueLabel.textColor = ColorConfiguration.blodText.toColor()
            marginValueLabel.text = "--"
            marginValueLabel.adjustsFontSizeToFitWidth = true
            marginValueLabel.minimumScaleFactor = 0.5
        }
    }
    
    @IBOutlet weak var sendBgView: UIControl! {
        didSet {
            sendBgView.applyCornerRadius(10)
            sendBgView.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }
    
    @IBOutlet weak var joinBgView: UIControl! {
        didSet {
            joinBgView.applyCornerRadius(10)
            joinBgView.backgroundColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    @IBOutlet weak var sendLabel: UILabel! {
        didSet {
            sendLabel.textColor = ColorConfiguration.wihteText.toColor()
            sendLabel.text = "home_newGuaranty".toMultilingualism()
        }
    }
    
    @IBOutlet weak var joinLabel: UILabel! {
        didSet {
            joinLabel.textColor = ColorConfiguration.wihteText.toColor()
            joinLabel.text = "home_joinGuaranty".toMultilingualism()
        }
    }
    
    @IBOutlet weak var des1Label: UILabel! {
        didSet {
            des1Label.textColor = UIColor.white.withAlphaComponent(0.8)
            des1Label.adjustsFontSizeToFitWidth = true
            des1Label.minimumScaleFactor = 0.5
            des1Label.text = "我要创建一个担保申请".toMultilingualism()
        }
    }
    
    @IBOutlet weak var des2Label: UILabel! {
        didSet {
            des2Label.textColor = UIColor.white.withAlphaComponent(0.8)
            des2Label.adjustsFontSizeToFitWidth = true
            des2Label.minimumScaleFactor = 0.5
            des2Label.text = "我要参与一个担保申请".toMultilingualism()
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func commonInit() {
        
        NotificationCenter.default.rx.notification(.languageChanged).observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            self?.joinLabel.text = "home_joinGuaranty".toMultilingualism()
            self?.sendLabel.text = "home_newGuaranty".toMultilingualism()
            self?.guranteeDesLabel.text = "home_orders".toMultilingualism()
            self?.marginDesLabel.text = "home_amount".toMultilingualism()
        }).disposed(by: rx.disposeBag)
    }
}
