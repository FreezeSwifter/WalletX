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
            this.updateAccountInfo()
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
        
        if LocaleWalletManager.shared().currentWalletModel == nil {
            accountButton.setTitle("未登录".toMultilingualism(), for: .normal)
        } else {
            if let nickName = LocaleWalletManager.shared().userInfo?.data?.nickName, !nickName.isEmpty {
                accountButton.setTitle(nickName, for: .normal)
            } else {
                accountButton.setTitle(LocaleWalletManager.shared().userInfo?.data?.walletId, for: .normal)
            }
        }
    }
}

class HomeNavigationBarView: UIView {
    
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
}
