//
//  JoinGuaranteeStepTwoController.swift
//  WalletX
//
//  Created by DZSB-001968 on 26.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx

class JoinGuaranteeStepTwoController: UIViewController, HomeNavigationble {

    var model: GuaranteeInfoModel? {
        didSet {
            fetchData(walletId: model?.data?.sponsorUser ?? "")
        }
    }
    var userModel: UserInfoModel?
    
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueTextField1: UITextField! {
        didSet {
            valueTextField1.placeholder = "请输入担保ID".toMultilingualism()
            valueTextField1.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.text = "担保类型".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueTextField2: UITextField! {
        didSet {
            valueTextField2.placeholder = "担保类型".toMultilingualism()
            valueTextField2.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var desLabel3: UILabel! {
        didSet {
            desLabel3.text = "home_amount".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueTextField3: UITextField! {
        didSet {
            valueTextField3.placeholder = "请输入担保金额".toMultilingualism()
            valueTextField3.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var desLabel4: UILabel! {
        didSet {
            desLabel4.text = "担保协议".toMultilingualism()
        }
    }
    
    @IBOutlet weak var pasteButton: UIButton! {
        didSet {
            pasteButton.setTitle("粘贴".toMultilingualism(), for: .normal)
            pasteButton.titleLabel?.minimumScaleFactor = 0.5
            pasteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var textViewBg: UIView! {
        didSet {
            textViewBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var agreeButton: UIButton! {
        didSet {
            agreeButton.setTitle("加入担保同意".toMultilingualism(), for: .normal)
            agreeButton.setImage(UIImage(named: "guarantee_check_box1"), for: .normal)
            agreeButton.setImage(UIImage(named: "guarantee_check_box2"), for: .selected)
            agreeButton.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: .normal)
            agreeButton.titleLabel?.minimumScaleFactor = 0.8
            agreeButton.titleLabel?.adjustsFontSizeToFitWidth = true
            agreeButton.centerTextAndImage(spacing: 8)
        }
    }
    
    @IBOutlet weak var contactButton: UIButton! {
        didSet {
            contactButton.setTitle("联系对方".toMultilingualism(), for: .normal)
            contactButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            contactButton.layer.cornerRadius = 10
            contactButton.layer.borderWidth = 1
            contactButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
            contactButton.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var joinButton: UIButton! {
        didSet {
            joinButton.setTitle("加入".toMultilingualism(), for: .normal)
            joinButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            joinButton.layer.cornerRadius = 10
            joinButton.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }
    
    private func fetchData(walletId: String) {
        let req: Observable<UserInfoModel?> = APIProvider.rx.request(.queryContactInfo(walletId: walletId)).mapModel()
        req.subscribe(onNext: {[weak self] info in
            self?.userModel = info
        }).disposed(by: rx.disposeBag)
    }
    
    private func bind() {
        agreeButton.rx.tap.subscribe(onNext: {[unowned self] in
            
            self.agreeButton.isSelected = !self.agreeButton.isSelected
            
        }).disposed(by: rx.disposeBag)
        
        joinButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.joinAssure()
        }).disposed(by: rx.disposeBag)
        
        textView.rx.text.map { "\($0?.count.description ?? "")" + "/1000" }.bind(to: countLabel.rx.text).disposed(by: rx.disposeBag)
        
        valueTextField1.text = model?.data?.assureId
        valueTextField2.text = model?.data?.assureTypeToString()
        valueTextField3.text = "\(model?.data?.amount ?? 0)"
        textView.text = model?.data?.agreement
        
        contactButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.openTg()
            
        }).disposed(by: rx.disposeBag)
        
        pasteButton.rx.tap.subscribe(onNext: {[unowned self] in
            UIPasteboard.general.string = self.textView.text
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
    }

    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "home_joinGuaranty".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }
    
    private func openTg() {
        guard let id = userModel?.data?.tg else {
            APPHUD.flash(text: "No Telegram ID")
            return
        }
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
    
    private func joinAssure() {
        guard let id = model?.data?.assureId else {
            return
        }
        
        if !agreeButton.isSelected {
            APPHUD.flash(text: "请勾选条款".toMultilingualism())
            return
        }
        
        APIProvider.rx.request(.assureOrderJoin(assureId: id, agreeFlag: agreeButton.isSelected)).mapJSON().subscribe(onSuccess: {[weak self] obj in
            guard let dict = obj as? [String: Any], let message = dict["message"] as? String, let this = self else { return }
            
            if message == "Success" {
                let notiTitle = LanguageManager.shared().replaceBraces(inString: "成功加入担保弹窗标题".toMultilingualism(), with: self?.valueTextField1.text ?? "")
                
                GuaranteeYesNoView.showFromBottom(image: UIImage(named: "guarantee_celebration"), title: notiTitle, titleIcon: nil, content: "成功加入担保弹窗内容".toMultilingualism(), leftButton: "提醒对方上押".toMultilingualism(), rightButton: "我来上押".toMultilingualism()).subscribe(onNext: {[weak self] index in
               
                    if index == 1 {
                        self?.navigationController?.popToRootViewController(animated: false)
                        let vc: DepositingDetailController = ViewLoader.Storyboard.controller(from: "Me")
                        vc.hidesBottomBarWhenPushed = true
                        var m = GuaranteeInfoModel.Meta()
                        m.assureId = self?.model?.data?.assureId
                        vc.model = m
                        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                        
                    } else if index == 0 {
                        
                        let vc: ContactOtherController = ViewLoader.Storyboard.controller(from: "Me")
                        
                        if self?.model?.data?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
                            vc.walletId = self?.model?.data?.sponsorUser
                        } else {
                            vc.walletId = self?.model?.data?.sponsorUser
                        }
                        
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }).disposed(by: this.rx.disposeBag)
            } else {
                APPHUD.flash(text: message)
            }
            
        }).disposed(by: rx.disposeBag)
    }
}
