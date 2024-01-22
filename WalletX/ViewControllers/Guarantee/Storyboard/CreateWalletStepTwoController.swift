//
//  CreateWalletStepTwoController.swift
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
import SnapKit

class CreateWalletStepTwoController: UIViewController, HomeNavigationble {
    
    @IBOutlet weak var notiLabel: UILabel! {
        didSet {
            notiLabel.text = "创建钱包第二步提醒".toMultilingualism()
        }
    }
    
    @IBOutlet weak var waringButton: UIButton!
    
    @IBOutlet weak var layoutView: QMUIFloatLayoutView! {
        didSet {
            layoutView.minimumItemSize = CGSize(width: (layoutView.bounds.size.width - 35) / 2, height: 40)
            layoutView.itemMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        }
    }
    
    @IBOutlet weak var copyButton: UIButton! {
        didSet {
            copyButton.layer.cornerRadius = 4
            copyButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
            copyButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var redLabel: UILabel! {
        didSet {
            redLabel.text = "创建钱包第二步红字".toMultilingualism()
        }
    }
    
    @IBOutlet weak var bottomButton: UIButton! {
        didSet {
            bottomButton.layer.cornerRadius = 10
            bottomButton.setupAPPUISolidStyle(title: "继续".toMultilingualism())
        }
    }
    
    private var mnemoic: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        mnemoic = LocaleWalletManager.shared().createWallet()
        let items = mnemoic?.components(separatedBy: " ")
        
        items?.enumerated().forEach { i, str in
            let btn = QMUIButton(type: .custom)
            btn.setTitle("\(i + 1)  \(str)", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            btn.setTitleColor(ColorConfiguration.blackText.toColor(), for: .normal)
            btn.titleLabel?.minimumScaleFactor = 0.5
            btn.layer.borderWidth = 1
            btn.layer.borderColor = ColorConfiguration.garyLine.toColor().withAlphaComponent(0.8).cgColor
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.applyCornerRadius(4)
            layoutView.addSubview(btn)
        }
        
        bottomButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc: VerifyPhraseController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.mnemoicList = items ?? []
            self?.showTipAlert {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: rx.disposeBag)
        
        copyButton.rx.tap.subscribe(onNext: {[weak self] _ in
            if let copyStr = self?.mnemoic {
                UIPasteboard.general.string = copyStr
                APPHUD.flash(text: "已完成".toMultilingualism())
            }
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "你的助记词".toMultilingualism()
        headerView?.backgroundColor = .white
        
    }
    
    private func showTipAlert(callback: @escaping () -> Void) {
        let alertView = MnemonicAlertView(frame: view.bounds)
        alertView.backgroundColor = ColorConfiguration.blackText.toColor().withAlphaComponent(0.5)
        alertView.confirmClosure = {
            alertView.removeFromSuperview()
            callback()
        }
        view.addSubview(alertView)
    }
}


class MnemonicAlertView: UIView {
    var confirmClosure: () -> Void = {}
    private lazy var titleLabel: UILabel = UILabel().then { it in
        it.text = "切勿与任何人分享您的助记词".toMultilingualism()
        it.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        it.numberOfLines = 1
        it.textAlignment = .center
    }
    
    private lazy var innerContainer: UIView = UIView().then { it in
        it.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        it.layer.cornerRadius = 16
        it.backgroundColor = .white
    }
    
    private lazy var verticalStackView: UIStackView = UIStackView().then { it in
        it.distribution = .fillEqually
        it.alignment = .fill
        it.spacing = 12
        it.axis = .vertical
    }
    
    private lazy var noteLabel: UILabel = UILabel().then { it in
        it.text = "noteTip".toMultilingualism()
        it.font = UIFont.systemFont(ofSize: 16)
        it.numberOfLines = 0
        it.textColor = UIColor(hex: "#FF5966")
    }
    
    
    private lazy var button: UIButton = UIButton(type: .custom).then { it in
        it.setTitle("继续".toMultilingualism(), for: .normal)
        it.setTitleColor(.white, for: .normal)
        it.backgroundColor = ColorConfiguration.primary.toColor()
        it.layer.cornerRadius = 4
        it.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        it.clipsToBounds = true
        it.addTarget(self, action: #selector(didBtnClick), for: .touchUpInside)
    }
    
    private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAlertView)).then { it in
        it.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(innerContainer)
        addGestureRecognizer(tapGesture)
        innerContainer.addSubview(titleLabel)
        innerContainer.addSubview(verticalStackView)
        insertStackViewItem(with: "listitem1".toMultilingualism(), in: verticalStackView)
        insertStackViewItem(with: "listitem2".toMultilingualism(), in: verticalStackView)
        insertStackViewItem(with: "listitem3".toMultilingualism(), in: verticalStackView)
        insertStackViewItem(with: "listitem4".toMultilingualism(), in: verticalStackView)
        innerContainer.addSubview(noteLabel)
        innerContainer.addSubview(button)
        
        innerContainer.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(noteLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(isIphoneXseries() ? -54 : -34)
        }
    }
    
    @objc
    private func didBtnClick() {
        confirmClosure()
    }
    
    @objc
    private func dismissAlertView() {
        removeFromSuperview()
    }
    
    private func insertStackViewItem(with content: String, in verticalStackView: UIStackView) {
        let stackView = UIStackView().then { it in
            it.distribution = .fill
            it.alignment = .top
            it.axis = .horizontal
            it.spacing = 0
        }
        
        let container = UIView().then { it in
            
        }
        
        let dotView = UIView().then { it in
            it.layer.cornerRadius = 3
            it.backgroundColor = ColorConfiguration.blodText.toColor()
        }
        container.addSubview(dotView)
        
        let contentLabel = UILabel().then { it in
            it.text = content
            it.numberOfLines = 0
            it.font = UIFont.systemFont(ofSize: 15)
            it.textColor = ColorConfiguration.blodText.toColor()
        }
        
        stackView.addArrangedSubview(container)
        container.snp.makeConstraints { make in
            make.height.width.equalTo(14)
        }
        dotView.snp.makeConstraints { make in
            make.height.width.equalTo(6)
            make.centerY.equalToSuperview()
        }
        stackView.addArrangedSubview(contentLabel)
        verticalStackView.addArrangedSubview(stackView)
    }
    
    /// 是否刘海屏
    private func isIphoneXseries() -> Bool {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = scene.windows.first {
            return window.safeAreaInsets.bottom > 0
        }
        
        return false
    }
}

extension MnemonicAlertView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let tapPoint = gestureRecognizer.location(in: gestureRecognizer.view)
        return !innerContainer.frame.contains(tapPoint)
    }
}

