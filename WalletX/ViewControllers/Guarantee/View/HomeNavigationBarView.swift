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
        let v: HomeNavigationBarView = ViewLoader.Xib.view()
        self.headerView = v
        self.view.addSubview(v)
        self.headerView?.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(self.qmui_navigationBarMaxYInViewCoordinator)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}

class HomeNavigationBarView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var serverButton: UIButton!
    
    @IBOutlet weak var scanButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
