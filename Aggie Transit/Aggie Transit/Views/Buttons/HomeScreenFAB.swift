//
//  HomeScreenFAB.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/4/22.
//

import Foundation
import UIKit

enum HomeScreenFABPath: String {
    case settings = "HomeScreenSettingsFAB"
    case notifications = "HomeScreenNotificationsFAB"
}

enum ButtonName: String {
    case settings = "Settings Button"
    case notifications = "Notifications Button"
}

class HomeScreenFAB: UIButton {
    let backgroundImage: HomeScreenFABPath
    var buttonName: ButtonName
    
    init(frame: CGRect, backgroundImage:HomeScreenFABPath, buttonName:ButtonName){
        self.backgroundImage = backgroundImage
        self.buttonName = buttonName
        super.init(frame: frame)
        if let buttonBackgroundImage = UIImage(named: self.backgroundImage.rawValue) {
            self.setBackgroundImage(buttonBackgroundImage, for: .normal)
            self.imageView?.contentMode = .scaleAspectFit
        }
    
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
