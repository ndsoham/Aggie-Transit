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
        super.setBackgroundImage(self.backgroundImage, for: .normal)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
