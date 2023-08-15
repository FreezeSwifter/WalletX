//
//  WalletViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit
import SnapKit
import JXSegmentedView

class WalletViewController: UIViewController, HomeNavigationble {

    private let topOperatedView: WalletHeaderView = ViewLoader.Xib.view()
    private let titleData: [String] = ["wallet_tokens".toMultilingualism(), "wallet_signature".toMultilingualism()]
    
    private lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let ds = JXSegmentedTitleDataSource()
        ds.isTitleColorGradientEnabled = true
        ds.titleNormalColor = ColorConfiguration.descriptionText.toColor()
        ds.titleSelectedColor = ColorConfiguration.blackText.toColor()
        ds.itemSpacing = 20
        ds.isItemSpacingAverageEnabled = false
        ds.titleNormalFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        ds.isTitleZoomEnabled = false
        ds.titleSelectedZoomScale = 1
        ds.titles = titleData
        return ds
    }()
    
    private let segmentedView = JXSegmentedView()
    
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        let segContainerView = JXSegmentedListContainerView(dataSource: self, type: .scrollView)
        return segContainerView
    }()
    
    private lazy var childVC: [JXSegmentedListContainerViewListDelegate] = [WalletTokenViewController(), WalletSignatureViewController()]
    
    private let noWalletView: WalletWithoutWalletView = ViewLoader.Xib.view()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorConfiguration.homeItemBg.toColor()
        self.fd_prefersNavigationBarHidden = true
        setupView()
    }

    
    private func setupView() {
        
        setupNavigationbar()
        headerView?.stackView.removeArrangedSubview(headerView!.linkButton)
        headerView?.linkButton.removeFromSuperview()
        headerView?.backgroundColor = .clear
        
        view.addSubview(topOperatedView)
        topOperatedView.snp.makeConstraints { make in
            make.top.equalTo(headerView!.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(42)
            make.height.equalTo(220)
        }
    
        topOperatedView.topButton1.setTitle("$0.00", for: UIControl.State())
        topOperatedView.topButton1.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        topOperatedView.topButton1.titleLabel?.minimumScaleFactor = 0.8
        topOperatedView.topButton1.setTitleColor(ColorConfiguration.blodText.toColor(), for: UIControl.State())
        
        topOperatedView.topButton2.setTitle("Wallet Address  ", for: UIControl.State())
        topOperatedView.topButton2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        topOperatedView.topButton2.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: UIControl.State())
        topOperatedView.topButton2.setImage(UIImage(named: "wallet_down_arrow"), for: UIControl.State())
        topOperatedView.topButton2.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        topOperatedView.topButton2.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        topOperatedView.topButton2.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        view.addSubview(segmentedView)
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = ColorConfiguration.blackText.toColor()
        segmentedView.indicators = [indicator]
        
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(topOperatedView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        listContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
        }
        segmentedView.backgroundColor = .white
        
        // 判断是否需要展示
        view.addSubview(noWalletView)
        noWalletView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.4, delay: 5) {
            self.noWalletView.alpha = 0
        }
       
    }

}


extension WalletViewController: JXSegmentedListContainerViewDataSource {
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        
        return segmentedDataSource.titles.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        return childVC[index]
    }
}


extension WalletViewController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {

    }
}
