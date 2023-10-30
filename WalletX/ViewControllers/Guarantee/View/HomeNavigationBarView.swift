//
//  HomeNavigationBarView.swift
//  WalletX
//
//  Created by DZSB-001968 on 11.8.23.
//

import UIKit
import QMUIKit

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
        // 暂时不用显示这个按钮
        headerView?.stackView.removeArrangedSubview(headerView!.linkButton)
        headerView?.linkButton.removeFromSuperview()
        headerView?.backgroundColor = .clear
        
        headerView?.stackView.removeArrangedSubview(headerView!.scanButton)
        headerView?.scanButton.removeFromSuperview()
    }
    
    func setupChildVCStyle() {
        headerView?.stackView.removeArrangedSubview(headerView!.scanButton)
        headerView?.scanButton.removeFromSuperview()
        headerView?.stackView.removeArrangedSubview(headerView!.shareButton)
        headerView?.shareButton.removeFromSuperview()
        headerView?.stackView.removeArrangedSubview(headerView!.serverButton)
        headerView?.serverButton.removeFromSuperview()
        headerView?.settingButton.setImage(UIImage(named: "navigation_back_button"), for: UIControl.State())
        headerView?.settingButton.tintColor = ColorConfiguration.blodText.toColor()
    }
}

class HomeNavigationBarView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var serverButton: UIButton!
    
    @IBOutlet weak var scanButton: UIButton!
    
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
