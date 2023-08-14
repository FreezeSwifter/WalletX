//
//  ColorConfiguration.swift
//  WalletX
//
//  Created by DZSB-001968 on 14.8.23.
//

import Foundation


enum ColorConfiguration {
  
    case primary // 主色
    case descriptionText // 描述文字
    case blackText // 黑色文字
    case wihteText // 白色文字
    case blodText // 加粗文字
    case lightBlue // 首页淡蓝色
    
    
    func toColor() -> UIColor {
        switch self {
        case .primary:
            return UIColor.qmui_color(withHexString: "#4162FF") ?? .systemBlue
            
        case .descriptionText:
            return UIColor.qmui_color(withHexString: "#999999") ?? .gray
            
        case .blackText:
            return UIColor.qmui_color(withHexString: "#333333") ?? .black
         
        case .wihteText:
            return UIColor.qmui_color(withHexString: "#FFFFFF") ?? .white
            
        case .blodText:
            return UIColor.qmui_color(withHexString: "#271F13") ?? .black
            
        case .lightBlue:
            return UIColor.qmui_color(withHexString: "#40BCFC") ?? .blue
        }
        
    }
}
