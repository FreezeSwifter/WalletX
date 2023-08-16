//
//  MyViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit

class MyViewController: UIViewController, HomeNavigationble {
    
    let infoView: MeInfoView = ViewLoader.Xib.view()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        setupNavigationbar()
        
        if let cgImage = UIImage(named: "me_background")?.cgImage {
            view.layer.contents = cgImage
        }
        
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView!.snp.bottom).offset(2)
            make.height.equalTo(124)
        }
    }
    
}
