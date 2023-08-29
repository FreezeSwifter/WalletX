//
//  GuaranteeingCell.swift
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

class GuaranteeingCell: UITableViewCell {
    
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
    
    @IBOutlet weak var desLabel5Me: UILabel! {
        didSet {
            desLabel5Me.text = "我".toMultilingualism()
            desLabel5Me.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            desLabel5Me.minimumScaleFactor = 0.4
        }
    }
    
    @IBOutlet weak var desLabel5: UILabel! {
        didSet {
            desLabel5.text = "参与人".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel6: UILabel! {
        didSet {
            desLabel6.text = "钱包地址".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel1: UILabel!
    
    @IBOutlet weak var valueLabel1Status: UILabel!
    
    @IBOutlet weak var protocolBg: UIStackView! {
        didSet {
            protocolBg.isLayoutMarginsRelativeArrangement = true
            protocolBg.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            protocolBg.applyCornerRadius(protocolBg.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        }
    }
    
    @IBOutlet weak var protocolLabel: UILabel! {
        didSet {
            protocolLabel.text = "协议".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel2: UILabel!
    
    @IBOutlet weak var valueLabel3: UILabel!
    
    @IBOutlet weak var valueLabel4: UILabel!
    
    @IBOutlet weak var valueLabel5: UILabel!
    
    @IBOutlet weak var valueLabel6: UILabel!
    
    @IBOutlet weak var valueLabel5sub: UILabel!
    
    @IBOutlet weak var valueLabel4sub: UILabel!
    
    @IBOutlet weak var valueLabel6Button: UIButton! {
        didSet {
            valueLabel6Button.setTitle("share_Copy".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var button1: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var button2: UIButton! {
        didSet {
            button2.setupAPPUIHollowStyle(title: "联系对方".toMultilingualism())
        }
    }
    
    @IBOutlet weak var button3: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var button4: UIButton! {
        didSet {
            button4.setupAPPUISolidStyle(title: "申请解押".toMultilingualism())
        }
    }
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        desLabel5Me.snp.remakeConstraints { make in
            make.width.height.equalTo(26)
        }
        desLabel5Me.clipsToBounds = true
        desLabel5Me.layer.cornerRadius = 13
        
        bind()
    }
    
    private func bind() {
        button4.rx.tap.subscribe(onNext: {[unowned self] _ in
            
            if self.button4.titleLabel?.text == "申请解押".toMultilingualism() {
                let vc: OrderOperationViewController = ViewLoader.Storyboard.controller(from: "Me")
                vc.state = .applyRelease
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    func switchUI(state: MyListStatus) {
        layoutIfNeeded()
        if state == .guaranteeing {
            if button1 != nil {
                buttonStackView.removeArrangedSubview(button1)
                button1.removeFromSuperview()
            }
            if button3 != nil {
                buttonStackView.removeArrangedSubview(button3)
                button3.removeFromSuperview()
            }
            if button2 != nil {
                if !buttonStackView.arrangedSubviews.contains(button2) {
                    buttonStackView.addArrangedSubview(button2)
                }
                button2.setupAPPUIHollowStyle(title: "联系对方".toMultilingualism())
            }
            button4.setupAPPUISolidStyle(title: "申请解押".toMultilingualism())
        }
        
        if state == .releasing {
            if button1 != nil {
                if !buttonStackView.arrangedSubviews.contains(button1) {
                    buttonStackView.addArrangedSubview(button1)
                }
                button1.setupAPPUIHollowStyle(title: "联系客服".toMultilingualism())
            }
            
            if button3 != nil {
                if !buttonStackView.arrangedSubviews.contains(button3) {
                    buttonStackView.addArrangedSubview(button3)
                }
                button3.setupAPPUIHollowStyle(title: "撤销申请".toMultilingualism())
            }
            
            if button2 != nil {
                if !buttonStackView.arrangedSubviews.contains(button2) {
                    buttonStackView.addArrangedSubview(button2)
                }
                button2.setupAPPUIHollowStyle(title: "联系对方".toMultilingualism())
            }
            button4.setupAPPUISolidStyle(title: "处理解押".toMultilingualism())
        }
        
        if state == .released {
            if button1 != nil {
                buttonStackView.removeArrangedSubview(button1)
                button1.removeFromSuperview()
            }
            if button2 != nil {
                buttonStackView.removeArrangedSubview(button2)
                button2.removeFromSuperview()
            }
            
            button4.setupAPPUISolidStyle(title: "联系对方".toMultilingualism())
            if button3 != nil {
                if !buttonStackView.arrangedSubviews.contains(button3) {
                    buttonStackView.addArrangedSubview(button3)
                }
                button3.setupAPPUIHollowStyle(title: "联系客服".toMultilingualism())
            }
        }
    }
}
