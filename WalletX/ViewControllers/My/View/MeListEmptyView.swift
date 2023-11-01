//
//  MelistEmptyView.swift
//  WalletX
//
//  Created by DZSB-001968 on 17.8.23.
//

import UIKit
import SnapKit

class MeListEmptyView: UIView {
    
    lazy var listEmptyImageView: UIImageView = UIImageView(image: UIImage(named: "me_nodata"))
    
    lazy var label: UILabel = {
        let v = UILabel()
        v.textColor = ColorConfiguration.descriptionText.toColor()
        v.text = "me_nodata".toMultilingualism()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        addSubview(listEmptyImageView)
        addSubview(label)
        
        listEmptyImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(listEmptyImageView.snp.bottom).offset(30)
        }
    }
}

