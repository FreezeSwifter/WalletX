//
//  ScanViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 22.8.23.
//

import UIKit
import SGQRCode
import QMUIKit
import Then
import RxCocoa
import RxSwift
import NSObject_Rx
import ZLPhotoBrowser

class ScanViewController: UIViewController, HomeNavigationble {
    
    @IBOutlet weak var desLabel: UILabel! {
        didSet {
            desLabel.textColor = ColorConfiguration.wihteText.toColor()
            desLabel.backgroundColor = .black.withAlphaComponent(0.2)
            desLabel.text = nil
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    private let scanCode = SGScanCode()
    
    private let openLightButton: QMUIButton = QMUIButton(type: .custom).then { it in
        it.setTitle("scan_open_light".toMultilingualism(), for: .normal)
        it.setImage(UIImage(named: "global_open_light"), for: .normal)
        it.imagePosition = .top
        it.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
        it.spacingBetweenImageAndTitle = 10
    }
    
    private let albumButton: QMUIButton = QMUIButton(type: .custom).then { it in
        it.setTitle("scan_open_album".toMultilingualism(), for: .normal)
        it.setImage(UIImage(named: "global_open_album"), for: .normal)
        it.imagePosition = .top
        it.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
        it.spacingBetweenImageAndTitle = 10
    }
    
    private var scanView: SGScanView?
    
    private var  device: AVCaptureDevice?
    
    private var scanResultBlock: ((String?) -> Void)?
    
    deinit {
        
        do {
            try device?.lockForConfiguration()
            device?.torchMode = .off
            device?.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        if !scanCode.checkCameraDeviceRearAvailable() {
            APPHUD.flash(text: "home_setting_lock_error".toMultilingualism())
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.scanCode.preview = self.view
            self.scanCode.startRunning()
            self.scanView?.startScanning()
        })
        
        bind()
    }
    
    private func bind() {
        openLightButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.toggleFlash()
        }).disposed(by: rx.disposeBag)
        
        albumButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let this = self else { return }
            let ps = ZLPhotoPreviewSheet()
            
            ps.selectImageBlock = {results, isOriginal in
                guard let img = results.last?.image else {
                    return
                }
                self?.scanCode.readQRCode(img, completion: {[weak self] resultText in
                    if let res = resultText {
                        self?.scanResultBlock?(res)
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            }
            ps.showPhotoLibrary(sender: this)
            
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .black
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "scan_title".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        let config = SGScanViewConfigure()
        config.autoreverses = true
        config.isFromTop = true
        config.cornerLocation = .init(1)
        scanView = SGScanView(frame: imageView.frame, configure: config)
        imageView.addSubview(scanView!)
        scanView?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        scanCode.delegate = self
        scanCode.sampleBufferDelegate = self
        
        
        view.addSubview(openLightButton)
        view.addSubview(albumButton)
        openLightButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(58)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-107)
        }
        
        albumButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-58)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-107)
        }
    }
    
    private func toggleFlash() {
        guard
            let device = AVCaptureDevice.default(for: AVMediaType.video),
            device.hasTorch
        else { return }
        
        self.device = device
        do {
            try device.lockForConfiguration()
            openLightButton.isSelected = !openLightButton.isSelected
            if openLightButton.isSelected {
                device.torchMode = .on
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }
    
    static func generateQRCode(text: String, size: CGFloat) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                continuation.resume(returning: SGGenerateQRCode.generateQRCode(withData: text, size: size))
            }
        }
    }
    
    func scanCompletion(result: @escaping (String?)->Void) {
        self.scanResultBlock = result
    }
}

extension ScanViewController: SGScanCodeDelegate {
    
    func scanCode(_ scanCode: SGScanCode!, result: String!) {
        if result != nil && result.count > 0 {
            scanResultBlock?(result)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension ScanViewController: SGScanCodeSampleBufferDelegate {
    
    func scanCode(_ scanCode: SGScanCode!, brightness: CGFloat) {
        
    }
}
