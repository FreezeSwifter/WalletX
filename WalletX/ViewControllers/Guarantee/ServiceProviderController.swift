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

    var list: [CategoryModel] = [] {
        didSet {
            setupSegmentData()
        }
    }
    
    private lazy var notiView: ServiceProviderNotiView = ViewLoader.Xib.view()
    
    private var titleData = ["home_item_all".toMultilingualism()]
    
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
        ds.titles = []
        return ds
    }()
    
    private let segmentedView = JXSegmentedView()
    
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        let segContainerView = JXSegmentedListContainerView(dataSource: self, type: .scrollView)
        return segContainerView
    }()
    
    private lazy var childVC: [JXSegmentedListContainerViewListDelegate] = {
        let vc = ServiceProviderChildController()
        vc.index = 0
        return [vc]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func bind() {
   
    }
    
    private func setupSegmentData() {
        if list.count == 0 {
            let cartgoryListReq: Observable<[CategoryModel]> = APIProvider.rx.request(.serviceCategory).mapModelArray()
            cartgoryListReq.subscribe(onNext: {[weak self] list in
                self?.list = list
            }).disposed(by: rx.disposeBag)
            
        } else {
            let titleArray = list.compactMap { $0.category }
            let vcArray = list.enumerated().map { (index, obj) in
                let vc = ServiceProviderChildController()
                vc.index = index + 1
                vc.category = obj
                return vc
            }
            childVC.append(contentsOf: vcArray)
            titleData.append(contentsOf: titleArray)
            segmentedDataSource.titles = titleData
            segmentedView.reloadData()
        }
    }
    
    private func setupView() {
        view.backgroundColor = ColorConfiguration.grayBg.toColor()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "home_topService".toMultilingualism()
        
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
        
        return titleData.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        return childVC[index]
    }
}


extension ServiceProviderController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
    }
}
