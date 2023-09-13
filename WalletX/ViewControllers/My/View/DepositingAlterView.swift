//
//  DepositingAlterView.swift
//  WalletX
//
//  Created by DZSB-001968 on 28.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx
import MZTimerLabel
import SwiftDate

class DepositingAlterView: UIView {
    
    weak var oc: OverlayController?
    
    @IBOutlet weak var waitingLabel: QMUILabel! {
        didSet {
            waitingLabel.text = "等待创建多签钱包中".toMultilingualism()
            waitingLabel.contentEdgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
            waitingLabel.clipsToBounds = true
            waitingLabel.layer.cornerRadius = 7
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.text = "等待多签钱包创建中内容".toMultilingualism()
        }
    }
    
    @IBOutlet weak var leftButton: UIButton! {
        didSet {
            leftButton.setTitle("home_contact_us".toMultilingualism(), for: .normal)
            leftButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            leftButton.layer.cornerRadius = 10
            leftButton.layer.borderWidth = 1
            leftButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
            leftButton.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var rightButton: UIButton! {
        didSet {
            rightButton.setTitle("home_gotit".toMultilingualism(), for: .normal)
            rightButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            rightButton.layer.cornerRadius = 10
            rightButton.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }
    
    var timerLabel: MZTimerLabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        timerLabel = MZTimerLabel(label: timeLabel, andTimerType: MZTimerLabelType(rawValue: 1))
    }
    
    static func show(time: Double) -> Observable<Int> {
        return Observable.create { o in
            
            guard let topVc = UIApplication.topViewController() else {
                return Disposables.create {}
            }
            
            let baseHeight: CGFloat = 390
            let width = topVc.view.bounds.width - 80
            let contentView: DepositingAlterView = ViewLoader.Xib.view()
            
            contentView.do { it in
                it.frame = CGRect(x: 0, y: 0, width: width, height: baseHeight)
                it.layer.cornerRadius = 10
                it.leftButton.rx.tap.subscribe(onNext: {[weak it] _ in
                    o.onNext(0)
                    if let oc = it?.oc {
                        topVc.view.dissmiss(overlay: oc)
                    }
                }).disposed(by: it.rx.disposeBag)
                
                it.rightButton.rx.tap.subscribe(onNext: {[weak it] _ in
                    o.onNext(1)
                    if let oc = it?.oc {
                        topVc.view.dissmiss(overlay: oc)
                    }
                }).disposed(by: it.rx.disposeBag)
                
                let createTime = Date(timeIntervalSince1970: time / 1000 )
                let timeout = Int(AppArchiveder.shared().getAPPConfig(by: "multisigTimeout") ?? "0") ?? 0
                let endTime = createTime + timeout.minutes
                let countTime = endTime - Date()
                it.timerLabel?.setCountDownTime(countTime.timeInterval)
                it.timerLabel?.start()
            }
            
            let ovc = OverlayController(view: contentView)
            ovc.isDismissOnMaskTouched = false
            ovc.layoutPosition = .center
            ovc.presentationStyle = .transform(scale: 1.5)
            ovc.dismissonStyle = .transform(scale: 0.5)
            ovc.maskStyle = .black(opacity: 0.5)
            topVc.view.present(overlay: ovc)
            contentView.oc = ovc
            
            return Disposables.create {}
        }
    }
}
