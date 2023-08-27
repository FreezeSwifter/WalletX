//
//  MyViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit
import SnapKit
import JXSegmentedView
import SnapKit
import RxCocoa
import RxSwift
import NSObject_Rx


class MyViewController: UIViewController, HomeNavigationble {
    
    private static let titleData = ["me_all".toMultilingualism(), "me_pending".toMultilingualism(), "me_depositing".toMultilingualism(), "me_guaranteeing".toMultilingualism(), "me_releasing".toMultilingualism(), "me_released".toMultilingualism()]
    
    private var pagingView: JXPagingView!
    private var userHeaderContainerView: UIView = UIView()
    private let infoView: MeInfoView = ViewLoader.Xib.view()
    
    private lazy var segmentedContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.applyCornerRadius(10, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        return v
    }()
    
    private lazy var segmentedContainerTitleLabel: UILabel = {
        let v = UILabel(frame: .zero)
        v.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        v.textColor = ColorConfiguration.blodText.toColor()
        v.text = "me_guaranties".toMultilingualism()
        return v
    }()
    
    private lazy var segmentedContainerLine: UIView = {
        let v = UIView()
        v.backgroundColor = ColorConfiguration.garyLine.toColor()
        return v
    }()
    
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
        ds.titles = MyViewController.titleData
        return ds
    }()
    
    private let segmentedView = JXSegmentedView()
    
    private lazy var childVC: [JXSegmentedListContainerViewListDelegate] = MyViewController.titleData.enumerated().map { index, str -> JXSegmentedListContainerViewListDelegate in
        return MeListChildViewController()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.rx.notification(.languageChanged).observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            self?.tabBarItem.title = "tab_me".toMultilingualism()
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
     
    private func bind() {
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            let settingVC: SettingViewController = ViewLoader.Xib.controller()
            settingVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(settingVC, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
        headerView?.scanButton.rx.tap.subscribe(onNext: {[weak self] in
            let sancVC: ScanViewController = ViewLoader.Xib.controller()
            sancVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(sancVC, animated: true)
        }).disposed(by: rx.disposeBag)
        
        headerView?.shareButton.rx.tap.subscribe(onNext: {[weak self] in
            let shareVC: ShareViewController = ViewLoader.Xib.controller()
            shareVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(shareVC, animated: true)
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        setupNavigationbar()
        if let cgImage = UIImage(named: "me_background")?.cgImage {
            view.layer.contents = cgImage
        }
        
        view.addSubview(userHeaderContainerView)
        userHeaderContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView!.snp.bottom).offset(2)
            make.height.equalTo(124)
        }
        userHeaderContainerView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
       
//
//        view.addSubview(segmentedContainerView)
//        segmentedContainerView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(userHeaderContainerView.snp.bottom).offset(2)
//            make.height.equalTo(102)
//        }
//
//        segmentedContainerView.addSubview(segmentedContainerTitleLabel)
//        segmentedContainerView.addSubview(segmentedContainerLine)
//        segmentedContainerView.addSubview(segmentedView)
//        segmentedContainerTitleLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(16)
//            make.top.equalToSuperview().offset(20)
//        }
//        segmentedView.snp.makeConstraints { make in
//            make.top.equalTo(segmentedContainerTitleLabel.snp.bottom).offset(16)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(30)
//        }
//        segmentedContainerLine.snp.makeConstraints { make in
//            make.leading.bottom.trailing.equalToSuperview()
//            make.height.equalTo(0.5)
//        }
//
//        pagingView = JXPagingView(delegate: self)
//        segmentedView.dataSource = segmentedDataSource
//        view.addSubview(pagingView)
//        segmentedView.listContainer = pagingView.listContainerView
//
//        //配置指示器
//        let indicator = JXSegmentedIndicatorBackgroundView()
//        indicator.indicatorCornerRadius = 3
//        indicator.indicatorColor = UIColor.qmui_color(withHexString: "#EBECF0") ?? .gray
//        segmentedView.indicators = [indicator]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        pagingView.frame = view.bounds
    }
}


extension MyViewController: JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return 124
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return userHeaderContainerView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return 102
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return MyViewController.titleData.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let list = PagingListBaseView()
        if index == 0 {
            list.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]
        }else if index == 1 {
            list.dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]
        }else {
            list.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]
        }
        list.beginFirstRefresh()
        return list
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
    
    }
}


