//
//  WalletManagementController.swift
//  WalletX
//
//  Created by DZSB-001968 on 30.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx
import WalletCore

class WalletManagementController: UIViewController, HomeNavigationble {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .plain)
        tv.register(UINib(nibName: "WalletManagementCell", bundle: nil), forCellReuseIdentifier: "WalletManagementCell")
        tv.rowHeight = 80
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        
        return tv
    }()
    
    var datasouce: [WalletModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        datasouce = LocaleWalletManager.shared().fetchLocalWalletList() ?? []
        
        if let selectedIndex = datasouce.firstIndex(where: { m in
            return m.mnemoic == LocaleWalletManager.shared().currentWalletModel?.mnemoic
        }) {
            var selectedItem = datasouce[selectedIndex]
            selectedItem.isSelected = true
            datasouce[selectedIndex] = selectedItem
        }
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "钱包管理".toMultilingualism()
        headerView?.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView!.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        headerView?.stackView.addArrangedSubview(headerView!.shareButton)
        headerView?.shareButton.setImage(UIImage(named: "wallet_add_new"), for: .normal)
        headerView?.shareButton.rx.tap.subscribe(onNext: { _ in
      
            guard let topVc = AppDelegate.topViewController() else {
                return
            }
            let baseHeight: CGFloat = 600
            let width = topVc.view.bounds.width
            let contentView: WalletWithoutWalletView = ViewLoader.Xib.view()
            contentView.frame = CGRect(x: 0, y: 0, width: width, height: baseHeight)
            contentView.applyCornerRadius(10, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
            
            let ovc = OverlayController(view: contentView)
            contentView.ovc = ovc
            ovc.isDismissOnMaskTouched = true
            ovc.layoutPosition = .bottom
            ovc.presentationStyle = .fromToBottom
            ovc.maskStyle = .black(opacity: 0.5)
            topVc.view.present(overlay: ovc)
            
            contentView.do { it in
            
                let tap1 = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 60))
                it.noWaleetStack.gestureRecognizers?.forEach({ ges in
                    it.noWaleetStack.removeGestureRecognizer(ges)
                })
                it.noWaleetStack.addSubview(tap1)
                
                tap1.rx.tap.subscribe(onNext: { _ in
                    if let container = it.ovc {
                        topVc.view.dissmiss(overlay: container)
                    }
                    let vc: CreateWalletStepOneController = ViewLoader.Storyboard.controller(from: "Wallet")
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }).disposed(by: ovc.rx.disposeBag)
                
                let tap2 = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 60))
                it.hasWalletStack.gestureRecognizers?.forEach({ ges in
                    it.hasWalletStack.removeGestureRecognizer(ges)
                })
                it.hasWalletStack.addSubview(tap2)
                
                tap2.rx.tap.subscribe(onNext: { _ in
                    if let container = it.ovc {
                        topVc.view.dissmiss(overlay: container)
                    }
                    let vc: ImportWalletController = ViewLoader.Storyboard.controller(from: "Wallet")
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }).disposed(by: ovc.rx.disposeBag)
            }
        
        }).disposed(by: rx.disposeBag)
        
    }
}


extension WalletManagementController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletManagementCell", for: indexPath) as! WalletManagementCell
        let item = datasouce[indexPath.row]
        
        if item.walletId.isNotNilNotEmpty {
            cell.nameLabel.text = item.walletId
        }
        if item.name.isNotNilNotEmpty {
            cell.nameLabel.text = item.name
        }
        if item.nickName.isNotNilNotEmpty {
            cell.nameLabel.text = item.nickName
        }
        
        if item.isSelected {
            cell.nameLabel.textColor = ColorConfiguration.lightBlue.toColor()
            cell.imageIcon.image = UIImage(named: "wallet_management_list_icon")?.qmui_image(withTintColor: ColorConfiguration.lightBlue.toColor())
        } else {
            cell.nameLabel.textColor = ColorConfiguration.blackText.toColor()
            cell.imageIcon.image = UIImage(named: "wallet_management_list_icon")?.qmui_image(withTintColor: ColorConfiguration.blackText.toColor())
        }
        
        cell.button1.rx.tap.subscribe(onNext: {[weak self] in
            guard let this = self else { return }
            let accountSettingVC = AccountSettingViewController()
            this.navigationController?.pushViewController(accountSettingVC, animated: true)
        }).disposed(by: cell.rx.disposeBag)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        LocaleWalletManager.shared().didSelectedWallet(index: indexPath.row)
        navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "删除".toMultilingualism()) { [weak self] (action, view, resultClosure) in
            guard let this = self else {
                return
            }
            this.checkIsOpenFaceID {
                let deleteItem = this.datasouce[indexPath.row]
                LocaleWalletManager.shared().deleteWalletModel(by: deleteItem)
                this.datasouce.remove(at: indexPath.row)
                
                if let i = this.datasouce.firstIndex(where: { m in
                    return m.mnemoic == this.datasouce.first?.mnemoic
                }) {
                    LocaleWalletManager.shared().didSelectedWallet(index: i)
                }
                this.navigationController?.popViewController(animated: true)
            }
        }
        deleteAction.backgroundColor = UIColor(hex: "#FF5966")
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
    
    /// 检查是否开启FaceID
    private func checkIsOpenFaceID(callback: @escaping () -> Void) {
        if let isOpenLock = AppArchiveder.shared().mmkv?.bool(forKey: ArchivedKey.screenLock.rawValue), isOpenLock {
            let faceIdVC: FaceIDViewController = ViewLoader.Xib.controller()
            faceIdVC.modalPresentationStyle = .fullScreen
            faceIdVC.resultBlock = { isPass in
                if isPass {
                    callback()
                }
            }
            AppDelegate.topViewController()?.present(faceIdVC, animated: true)
        } else {
            callback()
        }
    }
}

