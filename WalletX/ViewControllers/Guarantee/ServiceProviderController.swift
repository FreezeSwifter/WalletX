//
//  ServiceProviderController.swift
//  WalletX
//
//  Created by DZSB-001968 on 21.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import JXSegmentedView

class ServiceProviderController: UIViewController, HomeNavigationble {

    private lazy var notiView: ServiceProviderNotiView = ViewLoader.Xib.view()
    
    private static var titleData = ["home_item_all".toMultilingualism(), "home_USDT".toMultilingualism(), "home_RMB".toMultilingualism(), "home_item_trade".toMultilingualism()]
    
    private lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let ds = JXSegmentedTitleDataSource()
        ds.isTitleColorGradientEnabled = true
        ds.titleNormalColor = ColorConfiguration.descriptionText.toColor()
        ds.titleSelectedColor = ColorConfiguration.blackText.toColor()
        ds.itemSpacing = 16
        ds.isItemSpacingAverageEnabled = false
        ds.titleNormalFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        ds.isTitleZoomEnabled = false
        ds.titleSelectedZoomScale = 1
        ds.titles = ServiceProviderController.titleData
        return ds
    }()
    
    private let segmentedView = JXSegmentedView()
    
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        let segContainerView = JXSegmentedListContainerView(dataSource: self, type: .scrollView)
        return segContainerView
    }()
    
    private lazy var childVC: [JXSegmentedListContainerViewListDelegate] = [ServiceProviderChildController(), ServiceProviderChildController(), ServiceProviderChildController(), ServiceProviderChildController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    private func setupView() {
        view.backgroundColor = ColorConfiguration.grayBg.toColor()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "home_topService".toMultilingualism()
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        view.addSubview(notiView)
        notiView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(headerView!.snp.bottom)
        }
        notiView.applyCornerRadius(10)
        
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(notiView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.listContainer = listContainerView
        
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom).offset(10)
        }
        
        //配置指示器
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorCornerRadius = 3
        indicator.indicatorColor = UIColor.qmui_color(withHexString: "#EBECF0") ?? .gray
        segmentedView.indicators = [indicator]

    }
}

extension ServiceProviderController: JXSegmentedListContainerViewDataSource {
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        
        return segmentedDataSource.titles.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        return childVC[index]
    }
}


extension ServiceProviderController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
    }
}
