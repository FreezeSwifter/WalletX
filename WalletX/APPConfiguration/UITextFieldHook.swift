//
//  UITextFieldHook.swift
//  WalletX
//
//  Created by DZSB-001968 on 19.12.23.
//

import Foundation
import UIKit
import ObjectiveC

extension UITextField {
    
    static let swizzleMethod: Void = {
        let originalSelector = #selector(UITextField.didMoveToSuperview)
        let newSelector = #selector(UITextField.swizzled_didMoveToSuperview)
        
        let oMethod = class_getInstanceMethod(UITextField.self, originalSelector)
        let nMethod = class_getInstanceMethod(UITextField.self, newSelector)
        
        let didAdd = class_addMethod(UITextField.self, originalSelector, method_getImplementation(nMethod!), method_getTypeEncoding(nMethod!))
        
        if didAdd {
            class_replaceMethod(UITextField.self, newSelector, method_getImplementation(oMethod!), method_getTypeEncoding(oMethod!))
        } else {
            method_exchangeImplementations(oMethod!, nMethod!)
        }
    }()
    
    @objc
    func swizzled_didMoveToSuperview() {
        self.swizzled_didMoveToSuperview()
        clearsOnBeginEditing = false
    }
}
