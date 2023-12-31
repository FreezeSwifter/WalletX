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
    case grayBg // 首页按钮正常状态 F4F5F6
    case homeItemBg // 首页服务item背景 ECF0F5
    case wihteAlpha80 // 白色 80% 透明度
    case garyLine // 808A9D 灰色分割线
    case originNotiText // #F0A158 橘黄色警告⚠️
    case originNotiBg //
    case listBg // 列表的背景色 F6F8FE
    case shareBg // 分享page的背景色 236 240 254
    case lightGray
    
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
            
        case .grayBg:
            return UIColor.qmui_color(withHexString: "#F4F5F6") ?? .gray
            
        case .homeItemBg:
            return UIColor.qmui_color(withHexString: "#ECF0F5") ?? .gray
            
        case .wihteAlpha80:
            return (UIColor.qmui_color(withHexString: "#FFFFFF") ?? .gray).qmui_colorWithAlphaAdded(toWhite: 0.8)
            
        case .garyLine:
            return (UIColor.qmui_color(withHexString: "#808A9D") ?? .gray).qmui_colorWithAlphaAdded(toWhite: 0.2)
            
        case .originNotiText:
            return UIColor.qmui_color(withHexString: "#F0A158") ?? .orange
            
        case .originNotiBg:
            return (UIColor.qmui_color(withHexString: "#F0A158") ?? .orange).qmui_colorWithAlphaAdded(toWhite: 0.1)
            
        case .listBg:
            return UIColor.qmui_color(withHexString: "#F6F8FE") ?? .orange
            
        case .shareBg:
            return UIColor.qmui_color(withHexString: "#ECF0FE") ?? .purple
        case .lightGray:
            return UIColor.qmui_color(withHexString: "#666666") ?? .lightGray
        }
    }
}

