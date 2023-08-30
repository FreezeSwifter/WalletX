//
//  LanguageManager.swift
//  WalletX
//
//  Created by DZSB-001968 on 14.8.23.
//

import Foundation
import MMKV
import RxCocoa
import RxSwift
import NSObject_Rx

enum LanguageCode: String {
    
    case cn
    case en
    
    func toDisplayText() -> String {
        switch self {
        case .cn:
            return "home_setting_cn".toMultilingualism()
        case .en:
            return "home_setting_en".toMultilingualism()
        }
    }
}

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
    
    var languageDidChanged: Observable<LanguageCode?> {
        return languageChangedSubject.asObservable().skip { item in
            return item == nil
        }.observe(on: MainScheduler.instance)
    }
    
    private(set) var currentCode: LanguageCode = .en
    private static let instance = LanguageManager()
    private var languageDict: [String: Any] = [:]
    private let languageChangedSubject: BehaviorSubject<LanguageCode?> = BehaviorSubject(value: nil)
    
    private override init() {
        if let loaclSave = MMKV.default()?.string(forKey: ArchivedKey.language.rawValue) as? String, let language = LanguageCode(rawValue: loaclSave){
            
            self.currentCode = language
        }
        
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
            if languageCode == "cn" {
                currentCode = .cn
            } else {
                currentCode = .en
            }
            
            if let localSave = MMKV.default()?.string(forKey: ArchivedKey.language.rawValue), let v = LanguageCode(rawValue: localSave) {
                currentCode = v
            }
            
            if let path = Bundle.main.path(forResource: currentCode.rawValue, ofType: "json"),
               let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
               let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                languageDict = jsonDict
            } else {
                assertionFailure("多语言JSON文件出错:\(languageCode)")
            }
        } else {
            guard let languageCode = NSLocale.current.languageCode else {
                return
            }
            if languageCode == "cn" {
                currentCode = .cn
            } else {
                currentCode = .en
            }
            
            if let localSave = MMKV.default()?.string(forKey: ArchivedKey.language.rawValue), let v = LanguageCode(rawValue: localSave) {
                currentCode = v
            }
            if let path = Bundle.main.path(forResource: currentCode.rawValue, ofType: "json"),
               let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
               let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                languageDict = jsonDict
            } else {
                assertionFailure("多语言JSON文件出错:\(languageCode)")
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
    
    func switchLanguage(to languageCode: LanguageCode) {
        guard currentCode != languageCode,
              let path = Bundle.main.path(forResource: languageCode.rawValue, ofType: "json"),
              let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            assertionFailure("多语言JSON文件出错:\(languageCode)")
            return
        }
        currentCode = languageCode
        languageDict = jsonDict
        
        MMKV.default()?.set(languageCode.rawValue, forKey: ArchivedKey.language.rawValue)
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        languageChangedSubject.onNext(currentCode)
    }
}

