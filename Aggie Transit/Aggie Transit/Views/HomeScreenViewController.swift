//
//  HomeScreenViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/4/22.
//

import Foundation
import UIKit

class HomeScreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let SettingsFAB = HomeScreenFAB(frame: CGRect(x: 100, y: 100, width: 40, height: 40), backgroundImage: UIImage(systemName: "house") ?? UIImage(), buttonName: "testButton")
        let NotificationsFab = HomeScreenFAB(frame: CGRect(x: 150, y: 100, width: 40, height: 40), backgroundImage: UIImage(systemName: "house.fill") ?? UIImage(), buttonName: "testButton")
        self.view.addSubview(SettingsFAB)
        self.view.addSubview(NotificationsFab)
    }
    
    
    @IBAction func handleButtonPress(sender: UIButton){
        if sender.currentTitle == "Settings Button"{
            
        }
        else if sender.currentTitle == "Notifications Button" {
            
        }
    }
    
    
}
