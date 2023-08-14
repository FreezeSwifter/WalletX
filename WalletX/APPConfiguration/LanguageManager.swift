//
//  LanguageManager.swift
//  WalletX
//
//  Created by DZSB-001968 on 14.8.23.
//

import Foundation

extension String {
    
    func toMultilingualism() -> String {
        return LanguageManager.shared().localizedString(forKey: self)
    }
}

@objcMembers
class LanguageManager: NSObject {
    
    private static let instance = LanguageManager()
    private var currentLanguage: String?
    private var languageDict: [String: Any] = [:]
    
    private override init() {
        super.init()
        loadLanguageFile()
    }
    
    @discardableResult
    static func shared() -> LanguageManager {
        return LanguageManager.instance
    }
    
    private func loadLanguageFile() {
        guard let languageCode = Locale.current.language.languageCode?.identifier else {
            return
        }
        
        if let path = Bundle.main.path(forResource: languageCode, ofType: "json"),
           let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            currentLanguage = languageCode
            languageDict = jsonDict
        }
    }
    
    func localizedString(forKey key: String) -> String {
        if let localizedString = languageDict[key] as? String {
            return localizedString
        }
        
        return key
    }
    
    func switchLanguage(to languageCode: String) {
        guard currentLanguage != languageCode,
              let path = Bundle.main.path(forResource: languageCode, ofType: "json"),
              let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            return
        }
        currentLanguage = languageCode
        languageDict = jsonDict
    }
}

