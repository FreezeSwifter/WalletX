//
//  APPHUD.swift
//  WalletX
//
//  Created by DZSB-001968 on 22.8.23.
//

import Foundation
import UIKit
import MBProgressHUD


final class APPHUD {
    
    private static var hud: MBProgressHUD?
    
    static func show(text: String?) {
        
        hide()
        guard let view = AppDelegate.topViewController()?.view else {
            return
        }
        
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = .text
        hud?.label.text = text
    }
    
    static func hide() {
        hud?.hide(animated: true)
        hud = nil
    }
    
    static func flash(text: String?) {
        hide()
        guard let view = AppDelegate.topViewController()?.view else {
            return
        }
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = .text
        hud?.label.text = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            hud?.hide(animated: true)
        })
    }
    
    static func showLoading(text: String?) {
        hide()
        guard let view = AppDelegate.topViewController()?.view else {
            return
        }
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = .indeterminate
        hud?.label.text = text
    }
}
