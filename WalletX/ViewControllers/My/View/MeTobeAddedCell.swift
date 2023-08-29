//
//  MeTobeAddedCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 28.8.23.
//

import UIKit

class MeTobeAddedCell: UITableViewCell {
    
    @IBOutlet weak var guaranteeIdDesLabel: UILabel! {
        didSet {
            guaranteeIdDesLabel.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var timeDesLabel: UILabel! {
        didSet {
            timeDesLabel.text = "发起时间".toMultilingualism()
        }
    }
    
    @IBOutlet weak var moneyDesLabel: UILabel! {
        didSet {
            moneyDesLabel.text = "担保金额没有1".toMultilingualism()
        }
    }
    
    @IBOutlet weak var creatorDesLabel: UILabel! {
        didSet  {
            creatorDesLabel.text = "发起人".toMultilingualism()
        }
    }
    
    @IBOutlet weak var meDesLabel: UILabel! {
        didSet {
            meDesLabel.text = "我".toMultilingualism()
            meDesLabel.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            meDesLabel.minimumScaleFactor = 0.4
        }
    }
    
    @IBOutlet weak var meIdDesLabel2: UILabel! {
        didSet {
            meIdDesLabel2.text = "参与人".toMultilingualism()
        }
    }
    
    @IBOutlet weak var idValueLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    
    @IBOutlet weak var moneyValueLabel: UILabel! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(MeTobeAddedCell.moneyLabelTap))
            moneyValueLabel.addGestureRecognizer(gesture)
            moneyValueLabel.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var creatorValueLabel: UILabel!
    @IBOutlet weak var meValueLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var topContractBg: UIStackView! {
        didSet {
            topContractBg.isLayoutMarginsRelativeArrangement = true
            topContractBg.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            topContractBg.applyCornerRadius(topContractBg.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        }
    }
    
    @IBOutlet weak var topContractDesLabel: UILabel! {
        didSet {
            topContractDesLabel.text = "协议".toMultilingualism()
        }
    }
    
    @IBOutlet weak var timeBg: UIView! {
        didSet {
            timeBg.layer.cornerRadius = timeBg.width / 2
            timeBg.clipsToBounds =  true
        }
    }
    
    @IBOutlet weak var timeIcon: UIImageView!
    
    @IBOutlet weak var waitingDesLabel: UILabel! {
        didSet {
            waitingDesLabel.text = "等待加入中".toMultilingualism()
            waitingDesLabel.minimumScaleFactor = 0.5
        }
    }
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var contactButton: UIButton! {
        didSet {
            contactButton.setupAPPUIHollowStyle(title: "联系对方".toMultilingualism())
        }
    }
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setupAPPUIHollowStyle(title: "取消担保".toMultilingualism())
        }
    }
    
    @IBOutlet weak var modifyButton: UIButton! {
        didSet {
            modifyButton.setupAPPUISolidStyle(title: "修改信息".toMultilingualism())
        }
    }
    
    @IBOutlet weak var inviteButton: UIButton! {
        didSet {
            inviteButton.setupAPPUISolidStyle(title: "邀请对方".toMultilingualism())
        }
    }
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        meDesLabel.snp.remakeConstraints { make in
            make.width.height.equalTo(26)
        }
        meDesLabel.clipsToBounds = true
        meDesLabel.layer.cornerRadius = 13
        
        bind()
    }
    
    func switchUI(state: MyListStatus) {
        layoutIfNeeded()
        if state == .pending {
            if cancelButton != nil {
                if !buttonStackView.arrangedSubviews.contains(cancelButton) {
                    buttonStackView.addArrangedSubview(cancelButton)
                }
            }
            
            if modifyButton != nil {
                if !buttonStackView.arrangedSubviews.contains(modifyButton) {
                    buttonStackView.addArrangedSubview(modifyButton)
                }
            }
            inviteButton.setTitle("邀请对方".toMultilingualism(), for: .normal)
        }
        
        if state == .depositing {
            if cancelButton != nil {
                buttonStackView.removeArrangedSubview(cancelButton)
                cancelButton.removeFromSuperview()
            }
            if modifyButton != nil {
                buttonStackView.removeArrangedSubview(modifyButton)
                modifyButton.removeFromSuperview()
            }
            inviteButton.setTitle("我来上押".toMultilingualism(), for: .normal)
        }
    }
    
    private func bind() {
        contactButton.rx.tap.subscribe(onNext: { _ in
            let vc: ContactOtherController = ViewLoader.Storyboard.controller(from: "Me")
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
        cancelButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            
            GuaranteeYesNoView.showFromBottom(image: UIImage(named: "me_cancel_alter_img"), title: "取消担保弹窗标题".toMultilingualism(), titleIcon: nil, content: "取消担保弹窗内容".toMultilingualism(), leftButton: "立即取消".toMultilingualism(), rightButton: "稍后再说".toMultilingualism()).subscribe(onNext: { _ in
                
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        inviteButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let this = self else { return }
            
            if this.inviteButton.titleLabel?.text == "我来上押".toMultilingualism() {
                
                DepositingAlterView.show().subscribe(onNext: { index in
                    
                    if index == 1 {
                        let vc: DepositingDetailController = ViewLoader.Storyboard.controller(from: "Me")
                        vc.hidesBottomBarWhenPushed = true
                        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }).disposed(by: this.rx.disposeBag)
            }
            
        }).disposed(by: rx.disposeBag)
    }
    
    @objc
    private func moneyLabelTap() {
        
        ChangeMoneyAlterVIew.show().subscribe(onNext: { index in
            
            if index == 0 {
                let vc: ContactOtherController = ViewLoader.Storyboard.controller(from: "Me")
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: rx.disposeBag)
    }
}
