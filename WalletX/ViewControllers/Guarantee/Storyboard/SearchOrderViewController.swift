//
//  SearchOrderViewController.swift
//  WalletX
//
//  Created by 张国忠 on 2023/12/5.
//

import UIKit
import Then

class SectionDesItem: UIView {
    private lazy var stackView: UIStackView = UIStackView().then { it in
        it.axis = .vertical
        it.distribution = .fill
        it.alignment = .fill
        it.spacing = 3
    }
    
    private lazy var titleLabel: UILabel = UILabel().then { it in
        it.font = UIFont.systemFont(ofSize: 15)
        it.textColor = ColorConfiguration.blackText.toColor()
    }
    
    private lazy var desLabel: UILabel = UILabel().then { it in
        it.font = UIFont.systemFont(ofSize: 12)
        it.textColor = ColorConfiguration.descriptionText.toColor()
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
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(desLabel)
        stackView.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
    }
    
    func updateItem(with title: String, desc: String, textAlignment: NSTextAlignment) {
        titleLabel.text = title
        titleLabel.textAlignment = textAlignment
        desLabel.text = desc
        desLabel.textAlignment = textAlignment
    }
}

class SearchOrderCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = UIImageView().then { it in
        it.contentMode = .scaleAspectFill
        it.image = UIImage(named: "app_logo_two")
    }
    
    private lazy var leftItem: SectionDesItem = SectionDesItem().then { it in
        
    }
    
    private lazy var rightItem: SectionDesItem = SectionDesItem().then { it in
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(leftItem)
        contentView.addSubview(rightItem)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.width.equalTo(36)
        }
        
        leftItem.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(rightItem.snp.leading)
        }
        
        rightItem.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    func updateCell(with model: GuaranteeInfoModel.Meta) {
        leftItem.updateItem(with: model.assureId ?? "", desc: model.assureTypeToString(), textAlignment: .left)
        if let amount = model.amount {
            rightItem.updateItem(with: "\(Int(amount))", desc: "USDT", textAlignment: .right)
        } else {
            rightItem.updateItem(with: "", desc: "USDT", textAlignment: .right)
        }
    }
}


class SearchOrderViewController: UIViewController, HomeNavigationble {
    private var filterList: [GuaranteeInfoModel.Meta] = []
    var list: [GuaranteeInfoModel.Meta] = [] {
        didSet {
            filterList = list
        }
    }
    
    private lazy var searchBar: UISearchBar = UISearchBar().then { it in
        it.searchTextField.font = UIFont.systemFont(ofSize: 14)
        it.searchTextField.textColor = ColorConfiguration.blackText.toColor().withAlphaComponent(0.9)
        it.searchTextField.setPlaceHolderTextColor(ColorConfiguration.garyLine.toColor().withAlphaComponent(0.4))
        it.searchTextField.placeholder = "担保ID".toMultilingualism()
        it.searchBarStyle = .minimal
        it.layer.cornerRadius = 18
        it.layer.masksToBounds = true
        it.delegate = self
        it.backgroundColor = ColorConfiguration.garyLine.toColor()
        it.setSearchFieldBackgroundImage(UIImage(color: ColorConfiguration.garyLine.toColor().withAlphaComponent(0.9), size: CGSizeMake(1, 36)), for: .normal)
    }
    
    private lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain).then { it in
        it.rowHeight = 90
        it.backgroundColor = .white
        it.separatorStyle = .none
        it.register(SearchOrderCell.self, forCellReuseIdentifier: "SearchOrderCell")
        it.delegate = self
        it.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.backgroundColor = .white
        headerView?.titleLabel.text = "待上押担保".toMultilingualism()
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            if let headerView = headerView {
                make.top.equalTo(headerView.snp.bottom)
            }
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(36)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func model(with indexPath: IndexPath) -> GuaranteeInfoModel.Meta? {
        guard indexPath.row >= 0 && indexPath.row < filterList.count else {
            return nil
        }
        return filterList[indexPath.row]
    }
}

extension SearchOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchOrderCell", for: indexPath) as! SearchOrderCell
        cell.selectionStyle = .none
        if let model = model(with: indexPath) {
            cell.updateCell(with: model)
        }
        return cell
    }
}

extension SearchOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = model(with: indexPath) {
            let vc = TransferOnsiteWalletController()
            vc.model = model
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchOrderViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filterList = list
        } else {
            filterList = list.filter({ item in
                if let assureId = item.assureId, !assureId.isEmpty {
                    return assureId.contains(searchText)
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
}
