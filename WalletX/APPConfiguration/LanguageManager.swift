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
    
    fileprivate func replacingFirstOccurrence(of target: String, with replacement: String) -> String {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replacement)
        }
        return self
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
        if #available(iOS 16, *) {
            guard let languageCode = Locale.current.language.languageCode?.identifier else {
                return
            }
            if let path = Bundle.main.path(forResource: languageCode, ofType: "json"),
               let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
               let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                currentLanguage = languageCode
                languageDict = jsonDict
            } else {
                assertionFailure("多语言JSON文件出错:\(languageCode)")
            }
        } else {
            guard let locale = NSLocale.current.languageCode else {
                return
            }
            if let path = Bundle.main.path(forResource: locale, ofType: "json"),
               let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
               let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                currentLanguage = locale
                languageDict = jsonDict
            } else {
                assertionFailure("多语言JSON文件出错:\(locale)")
            }
        }
    }
    
    func replaceBraces(inString string: String, with replacements: String...) -> String {
        var replacedString = string
        for replacement in replacements {
            replacedString = replacedString.replacingFirstOccurrence(of: "{}", with: replacement)
        }
        return replacedString
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

