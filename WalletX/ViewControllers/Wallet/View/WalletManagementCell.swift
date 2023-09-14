//
//  WalletManagementCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 30.8.23.
//

import UIKit
import QMUIKit

class WalletManagementCell: UITableViewCell {

    private static let changeColorImg =  UIImage(named: "wallet_management_list_icon")?.qmui_image(withTintColor: ColorConfiguration.blackText.toColor())
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var imageBg: UIView! {
        didSet {
            imageBg.layer.cornerRadius = imageBg.bounds.height / 2
            imageBg.layer.borderColor = ColorConfiguration.descriptionText.toColor().withAlphaComponent(0.5).cgColor
            imageBg.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var imageIcon: UIImageView! {
        didSet {
            
            imageIcon.image = WalletManagementCell.changeColorImg
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
