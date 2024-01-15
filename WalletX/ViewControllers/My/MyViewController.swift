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
    
    private var titleData: [String] = ["me_all".toMultilingualism(), "me_pending".toMultilingualism(), "me_depositing".toMultilingualism(), "me_guaranteeing".toMultilingualism(), "me_releasing".toMultilingualism(), "me_released".toMultilingualism()]
    
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
        ds.titleNormalFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        ds.isTitleZoomEnabled = false
        ds.titleSelectedZoomScale = 1
        ds.titles = titleData
        return ds
    }()
    
    
    private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editEmail))
    
    private let segmentedView = JXSegmentedView()
    
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        let segContainerView = JXSegmentedListContainerView(dataSource: self, type: .scrollView)
        segContainerView.scrollView.isScrollEnabled = false
        return segContainerView
    }()
    
    private lazy var childVC: [JXSegmentedListContainerViewListDelegate] = (0...6).enumerated().map { index, str -> JXSegmentedListContainerViewListDelegate in
        let vc = MeListChildViewController()
        vc.delegate = self
        switch index {
        case 0:
            vc.index = -1
        case 1:
            vc.index = 0
        case 2:
            vc.index = 1
        case 3:
            vc.index = 2
        case 4:
            vc.index = 9
        case 5:
            vc.index = 3
        default: break
        }
        return vc
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.rx.notification(.languageChanged).observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            self?.tabBarItem.title = "tab_me".toMultilingualism()
            self?.titleData.removeAll()
            self?.titleData = ["me_all".toMultilingualism(), "me_pending".toMultilingualism(), "me_depositing".toMultilingualism(), "me_guaranteeing".toMultilingualism(), "me_releasing".toMultilingualism(), "me_released".toMultilingualism()]
            self?.segmentedDataSource.titles = self?.titleData ?? []
            self?.segmentedView.reloadData()
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        infoView.walletAddressDes.text = "\("Gmail邮箱".toMultilingualism()): \(LocaleWalletManager.shared().userInfo?.data?.email ?? "未绑定".toMultilingualism())"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        headerView?.accountButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            LocaleWalletManager.checkLogin {
                self.toWalletManagementVC()
            }
        }).disposed(by: rx.disposeBag)
        
        headerView?.shareButton.rx.tap.subscribe(onNext: {[weak self] in
            let shareVC: ShareViewController = ViewLoader.Xib.controller()
            shareVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(shareVC, animated: true)
        }).disposed(by: rx.disposeBag)
        
        headerView?.serverButton.rx.tap.subscribe(onNext: { _ in
            let app = UIApplication.shared.delegate as? AppDelegate
            app?.openTg()
        }).disposed(by: rx.disposeBag)
        
        fetchData()
        
        NotificationCenter.default.rx.notification(.userInfoDidChangeed)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.fetchData()
        }).disposed(by: rx.disposeBag)

        infoView.walletAddressDes.addGestureRecognizer(tapGesture)
    }
    
    @objc private func editEmail() {
        if let email = LocaleWalletManager.shared().userInfo?.data?.email, !email.isEmpty {
        } else {
            SettingModifyAlterView.show(title: "修改邮箱账号".toMultilingualism(), text: nil, placeholder: "请输入".toMultilingualism(), leftButtonTitle: "取消".toMultilingualism(), rightButtonTitle: "确定".toMultilingualism()).flatMapLatest { str in
                
                guard let text = str, text.isNotEmpty else {
                    return Observable<Any>.empty()
                }
                func isValidEmail(email: String) -> Bool {
                    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
                    return emailPred.evaluate(with: email)
                }
                if !isValidEmail(email: text) {
                    APPHUD.flash(text: "请填写有效邮箱".toMultilingualism())
                    return Observable<Any>.empty()
                }
                
                let dict: [String: Any] = ["email": text]
                return APIProvider.rx.request(.userInfoSetting(info: dict)).mapJSON().asObservable()
                
            }.subscribe(onNext: { _ in
                APPHUD.flash(text: "成功".toMultilingualism())
                LocaleWalletManager.shared().fetchUserData(mnemonic: nil, walletName: nil, isAdd: false)
            }).disposed(by: rx.disposeBag)
        }
    }
    
    private func toWalletManagementVC() {
        let vc: WalletManagementController = WalletManagementController()
        vc.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchData() {
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
