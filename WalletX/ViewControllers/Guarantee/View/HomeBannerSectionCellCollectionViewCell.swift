//
//  HomeBannerSectionCellCollectionViewCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 12.8.23.
//

import UIKit
import Then
import Kingfisher

class HomeBannerSectionCellCollectionViewCell: UICollectionViewCell, FSPagerViewDataSource, FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        pageControl.currentPage = index
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage.init(named: "guarantee_service")
        let url = URL(string: "https://img2.baidu.com/it/u=1041327415,728509871&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=281")
        cell.imageView?.kf.setImage(with: url)
        cell.applyCornerRadius(7)
        return cell
    }
    
    lazy var pagerView: FSPagerView = {
        let v = FSPagerView(frame: .zero)
        v.dataSource = self
        v.delegate = self
        v.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        v.automaticSlidingInterval = 3
        return v
    }()
    
    lazy var pageControl: FSPageControl = {
        let v = FSPageControl(frame: .zero)
        v.numberOfPages = 3
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
 
    private func setupUI() {
        contentView.addSubview(pagerView)
        pagerView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
        }
    }
}
