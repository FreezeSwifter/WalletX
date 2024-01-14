//
//  HomeNavigationBarView.swift
//  WalletX
//
//  Created by DZSB-001968 on 11.8.23.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import SnapKit

extension UIViewController {
    
    private static let association = ObjectAssociation<HomeNavigationBarView>()
    
    var headerView: HomeNavigationBarView? {
        get { return UIViewController.association[self] }
        set { UIViewController.association[self] = newValue }
    }
}

protocol HomeNavigationble {
    
    func setupNavigationbar()
}

extension HomeNavigationble where Self: UIViewController {
    
    func setupNavigationbar() {
        self.fd_prefersNavigationBarHidden = true
        let v: HomeNavigationBarView = ViewLoader.Xib.view()
        headerView = v
        view.addSubview(v)
        headerView?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo((navigationController?.navigationBar.bounds.height ?? 88) + UIApplication.shared.statusBarFrame.size.height)
        }
        headerView?.backgroundColor = .clear
        
        LocaleWalletManager.shared().walletDidChanged.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            guard let this = self else { return }
            if let headerView = this.headerView, headerView.hasRightAccountBtn {
                this.updateRightAccountInfo()
            } else {
                this.updateAccountInfo()
            }
        }).disposed(by: rx.disposeBag)
        
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            let settingVC: SettingViewController = ViewLoader.Xib.controller()
            settingVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(settingVC, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
        updateAccountInfo()
    }
    
    func setupChildVCStyle() {
        headerView?.stackView.removeArrangedSubview(headerView!.settingButton)
        headerView?.settingButton.removeFromSuperview()
        headerView?.stackView.removeArrangedSubview(headerView!.shareButton)
        headerView?.shareButton.removeFromSuperview()
        headerView?.stackView.removeArrangedSubview(headerView!.serverButton)
        headerView?.serverButton.removeFromSuperview()
        headerView?.stackView.removeArrangedSubview(headerView!.messageButton)
        headerView?.messageButton.removeFromSuperview()
        headerView?.accountButton.setImage(UIImage(named: "navigation_back_button"), for: UIControl.State())
        headerView?.accountButton.tintColor = ColorConfiguration.blodText.toColor()
        headerView?.accountButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        headerView?.accountButton.setTitle(nil, for: .normal)
        headerView?.accountButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func updateAccountInfo() {
        guard let accountButton = headerView?.accountButton else {
            return
        }
        if UIApplication.topViewController() is WalletManagementController {
            return
        }
        
        updateAccountButtonUI(accountButton)
    }
    
    private func updateAccountButtonUI(_ button: UIButton) {
        if LocaleWalletManager.shared().currentWalletModel == nil {
            button.setTitle("未登录".toMultilingualism(), for: .normal)
        } else {
            if let nickName = LocaleWalletManager.shared().userInfo?.data?.nickName, !nickName.isEmpty {
                button.setTitle(nickName, for: .normal)
            } else {
                button.setTitle(LocaleWalletManager.shared().userInfo?.data?.walletId, for: .normal)
            }
        }
    }
    
    /// 导航栏右侧 显示账号按钮
    func setupRightAccountInfoBtn() {
        headerView?.addRightAccountInfoBtn()
        updateRightAccountInfo()
    }
    
    private func updateRightAccountInfo() {
        if let rightAccountInfoBtn = headerView?.rightAccountInfoBtn {
            updateAccountButtonUI(rightAccountInfoBtn)
            rightAccountInfoBtn.rx.tap.subscribe(onNext: { _ in
                LocaleWalletManager.checkLogin {
                    let vc: WalletManagementController = WalletManagementController()
                    vc.hidesBottomBarWhenPushed = true
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
            }).disposed(by: rx.disposeBag)
        }
    }
}

class HomeNavigationBarView: UIView {
    var hasRightAccountBtn: Bool {
        return rightAccountInfoBtn.superview != nil
    }
    
    lazy var rightAccountInfoBtn: QMUIButton = {
        let rightAccountInfoBtn = QMUIButton(type: .custom)
        rightAccountInfoBtn.setImage(UIImage(named: "导航栏下箭头"), for: .normal)
        rightAccountInfoBtn.imagePosition = .right
        rightAccountInfoBtn.spacingBetweenImageAndTitle = 6
        rightAccountInfoBtn.setTitleColor(ColorConfiguration.lightGray.toColor(), for: .normal)
        rightAccountInfoBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return rightAccountInfoBtn
    }()
    
    @IBOutlet weak var messageButton: UIButton! {
        didSet {
            messageButton.removeFromSuperview()
        }
    }
    @IBOutlet weak var accountButton: QMUIButton! {
        didSet {
            accountButton.setImage(UIImage(named: "导航栏下箭头"), for: .normal)
            accountButton.imagePosition = .right
            accountButton.spacingBetweenImageAndTitle = 6
            accountButton.setTitleColor(ColorConfiguration.lightGray.toColor(), for: .normal)
            accountButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            accountButton.cornerRadius = 4
            accountButton.layer.borderWidth = 1
            accountButton.layer.borderColor = ColorConfiguration.lightGray.toColor().cgColor
        }
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var serverButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = ColorConfiguration.blodText.toColor()
            titleLabel.minimumScaleFactor = 0.5
            titleLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addRightAccountInfoBtn() {
        addSubview(rightAccountInfoBtn)
        rightAccountInfoBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-8)
            make.height.equalTo(32)
        }
    }
}
