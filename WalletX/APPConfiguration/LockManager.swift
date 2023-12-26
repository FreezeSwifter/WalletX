//
//  LockManager.swift
//  WalletX
//
//  Created by DZSB-001968 on 26.12.23.
//

import UIKit
import HandyJSON

extension LockManager {
    
    class Item: HandyJSON {
        
        required init() {}
        
        convenience init(name: String?, value: Int) {
            self.init()
            self.name = name
            self.value = value
        }
        
        var name: String?
        var value: Int!
        var isSelected: Bool = false
    }
}


class LockManager: NSObject {
    
    @objc static let shareInstance = LockManager()
    
    var currentItem: LockManager.Item {
        return data[currentIndex]
    }
    
    @objc dynamic var currentIndex: Int {
        get {
            let v = UserDefaults.standard.integer(forKey: ArchivedKey.autolock.rawValue)
            return v
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: ArchivedKey.autolock.rawValue)
            UserDefaults.standard.synchronize()
            updateDataSource()
        }
    }
    
    private(set) var data: [Item] = [
        Item(name: "立即".toMultilingualism(), value: 0),
        Item(name: "1分钟".toMultilingualism(), value: 1),
        Item(name: "5分钟".toMultilingualism(), value: 5),
        Item(name: "1小时".toMultilingualism(), value: 60),
        Item(name: "5小时".toMultilingualism(), value: 300),
    ]
    
    private override init() {
        super.init()
        updateDataSource()
    }
    
    private func updateDataSource() {
        data = data.enumerated().map({ i, m in
            if currentIndex == i {
                m.isSelected = true
            } else {
                m.isSelected = false
            }
            return m
        })
    }
    
}
