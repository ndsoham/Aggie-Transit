//
//  HomeScreenFAB.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/4/22.
//

import Foundation
import UIKit

class HomeScreenFAB: UIButton {
    let backgroundImage: UIImage
    let buttonName: String
    
    init(frame: CGRect, backgroundImage:UIImage, buttonName:String){
        self.backgroundImage = backgroundImage
        self.buttonName = buttonName
        super.init(frame: frame)
        self.setBackgroundImage(self.backgroundImage, for: .normal)
        self.layer.borderColor = CGColor(red: 0.1, green: 0.3, blue: 0.5, alpha: 1)
        self.layer.borderWidth = CGFloat(floatLiteral: 1.0)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
