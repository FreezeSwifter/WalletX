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
        return list.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let item = list[index]
        let url = URL(string: item.imageUrl ?? "")
        cell.imageView?.kf.setImage(with: url)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.applyCornerRadius(7)
        return cell
    }
    
    var list: [BannerModel] = [] {
        didSet {
            pagerView.reloadData()
            pageControl.numberOfPages = list.count
        }
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
