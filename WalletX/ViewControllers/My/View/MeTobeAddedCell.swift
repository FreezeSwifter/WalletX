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
            contactButton.setTitle("联系对方".toMultilingualism(), for: .normal)
            contactButton.layer.cornerRadius = 10
            contactButton.layer.borderWidth = 1
            contactButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
            contactButton.titleLabel?.minimumScaleFactor = 0.5
            contactButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
    }
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setTitle("取消担保".toMultilingualism(), for: .normal)
            cancelButton.layer.cornerRadius = 10
            cancelButton.layer.borderWidth = 1
            cancelButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
            cancelButton.titleLabel?.minimumScaleFactor = 0.5
            cancelButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
    }
    
    @IBOutlet weak var modifyButton: UIButton! {
        didSet {
            modifyButton.setTitle("修改信息".toMultilingualism(), for: .normal)
            modifyButton.layer.cornerRadius = 10
            modifyButton.titleLabel?.minimumScaleFactor = 0.5
            modifyButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
    }
    
    @IBOutlet weak var inviteButton: UIButton! {
        didSet {
            inviteButton.setTitle("邀请对方".toMultilingualism(), for: .normal)
            inviteButton.layer.cornerRadius = 10
            inviteButton.titleLabel?.minimumScaleFactor = 0.5
            inviteButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
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
            buttonStackView.removeArrangedSubview(cancelButton)
            cancelButton.removeFromSuperview()
            buttonStackView.removeArrangedSubview(modifyButton)
            modifyButton.removeFromSuperview()
            inviteButton.setTitle("我来上押".toMultilingualism(), for: .normal)
        }
    }
    
    private func bind() {
        contactButton.rx.tap.subscribe(onNext: { _ in
            let vc: ContactOtherController = ViewLoader.Storyboard.controller(from: "Me")
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            
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
