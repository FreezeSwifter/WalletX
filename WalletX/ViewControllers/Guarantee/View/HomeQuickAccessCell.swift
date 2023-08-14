//
//  HomeQuickAccessCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 12.8.23.
//

import UIKit


class HomeQuickAccessCell: UICollectionViewCell {
    
    @IBOutlet weak var guranteeDesLabel: UILabel! {
        didSet {
            guranteeDesLabel.text = "home_orders".toMultilingualism()
            guranteeDesLabel.textColor = ColorConfiguration.descriptionText.toColor()
        }
    }
    
    @IBOutlet weak var guranteeValueLabel: UILabel! {
        didSet {
            guranteeValueLabel.textColor = ColorConfiguration.blodText.toColor()
            guranteeValueLabel.text = "--"
        }
    }
    
    @IBOutlet weak var marginDesLabel: UILabel! {
        didSet {
            marginDesLabel.text = "home_amount".toMultilingualism()
            marginDesLabel.textColor = ColorConfiguration.descriptionText.toColor()
        }
    }
    
    @IBOutlet weak var marginValueLabel: UILabel! {
        didSet {
            marginValueLabel.textColor = ColorConfiguration.blodText.toColor()
            marginValueLabel.text = "--"
        }
    }
    
    @IBOutlet weak var sendBgView: UIView! {
        didSet {
            sendBgView.applyCornerRadius(10)
            sendBgView.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }
    
    @IBOutlet weak var joinBgView: UIView! {
        didSet {
            joinBgView.applyCornerRadius(10)
            joinBgView.backgroundColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    @IBOutlet weak var sendLabel: UILabel! {
        didSet {
            sendLabel.textColor = ColorConfiguration.wihteText.toColor()
        }
    }
    
    @IBOutlet weak var joinLabel: UILabel! {
        didSet {
            joinLabel.textColor = ColorConfiguration.wihteText.toColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
