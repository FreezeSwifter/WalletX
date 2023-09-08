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
    
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        let segContainerView = JXSegmentedListContainerView(dataSource: self, type: .scrollView)
        return segContainerView
    }()
    
    private lazy var childVC: [JXSegmentedListContainerViewListDelegate] = MyViewController.titleData.enumerated().map { index, str -> JXSegmentedListContainerViewListDelegate in
        let vc = MeListChildViewController()
        vc.delegate = self
        return vc
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
        
        let getUserInfoReq: Observable<UserInfoModel?> = APIProvider.rx.request(.getUserInfo).mapModel()
        
        getUserInfoReq.subscribe(onNext: {[weak self] obj in
            self?.infoView.userInfo = obj
        }).disposed(by: rx.disposeBag)
        
        
    }
    
    private func setupView() {
        setupNavigationbar()
        
        if let cgImage = UIImage(named: "me_background")?.cgImage {
            view.layer.contents = cgImage
        }
        
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView!.snp.bottom)
            make.height.equalTo(124)
        }
        
        view.addSubview(segmentedContainerView)
        segmentedContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(infoView.snp.bottom)
            make.height.equalTo(102)
        }
        
        segmentedContainerView.addSubview(segmentedContainerTitleLabel)
        segmentedContainerView.addSubview(segmentedContainerLine)
        segmentedContainerView.addSubview(segmentedView)
        segmentedContainerTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
        }
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(segmentedContainerTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        segmentedContainerLine.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.listContainer = listContainerView
        
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(segmentedContainerView.snp.bottom)
        }
        
        //配置指示器
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorCornerRadius = 3
        indicator.indicatorColor = UIColor.qmui_color(withHexString: "#EBECF0") ?? .gray
        segmentedView.indicators = [indicator]
    }
}


extension MyViewController: JXSegmentedListContainerViewDataSource {
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        
        return segmentedDataSource.titles.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        return childVC[index]
    }
}


extension MyViewController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
    }
}

extension MyViewController: MeListChildViewDelegate {
    
    func listDidScroll(contentOffsetY: CGFloat) {
        
        let segmentedContainerOriginY = headerView!.height + infoView.height
        var segmentedContainerY: CGFloat = segmentedContainerOriginY
        segmentedContainerY -= contentOffsetY
        
        if segmentedContainerY <= headerView!.height {
            segmentedContainerY = headerView!.height
        }
        if segmentedContainerY >= segmentedContainerOriginY {
            segmentedContainerY = segmentedContainerOriginY
        }
        segmentedContainerView.frame = CGRect(x: 0, y: segmentedContainerY, width: segmentedContainerView.width, height: segmentedContainerView.height)
        
        let listOrigniY: CGFloat = segmentedContainerOriginY + segmentedContainerView.height
        var listY: CGFloat = listOrigniY
        listY -= contentOffsetY
        
        if listY <= segmentedContainerOriginY {
            listY = segmentedContainerOriginY - 22
        }
        if listY >= listOrigniY {
            listY = listOrigniY
        }
        
        listContainerView.frame = CGRect(x: 0, y: listY, width: listContainerView.width, height: listContainerView.height)
    }
}
