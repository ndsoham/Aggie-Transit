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
        // init buttons
        initializeFABButtons()
  
        
    }
    override func viewDidAppear(_ animated: Bool) {
        presentHomeScreenMenu2()
    }
  
    func initializeFABButtons(){
        // decide height and width of buttons based on the size of the phone
        let height = self.view.frame.height
        let width = self.view.frame.width
        let padding = height * (7.15/812)
        let fabHeight = CGFloat(floatLiteral: (height * (54.85/812)))
        let fabWidth = fabHeight
        // initialize buttons
        let homeScreenNotificationsFAB = HomeScreenFAB(frame: CGRect(x: 0, y: 0, width: fabWidth, height: fabHeight), backgroundImage: .notifications, buttonName: .notifications)
        let homeScreenSettingsFAB = HomeScreenFAB(frame: CGRect(x: 0, y: 0, width: fabWidth, height: fabHeight), backgroundImage: .settings, buttonName: .settings)
        
        //         fix the width and height of the buttons
        homeScreenSettingsFAB.widthAnchor.constraint(equalToConstant: fabWidth).isActive = true
        homeScreenNotificationsFAB.widthAnchor.constraint(equalToConstant: fabWidth).isActive = true
        homeScreenSettingsFAB.heightAnchor.constraint(equalToConstant: fabHeight).isActive = true
        homeScreenNotificationsFAB.heightAnchor.constraint(equalToConstant: fabHeight).isActive = true
        //         Add the buttons to a stack view
        homeScreenSettingsFAB.translatesAutoresizingMaskIntoConstraints = false
        homeScreenNotificationsFAB.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [homeScreenNotificationsFAB, homeScreenSettingsFAB])
        //         configure stack view
        stackView.axis = .vertical
        stackView.spacing = padding
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        //         Add constraints to the stack view
        let safeMargins = view.safeAreaLayoutGuide
        print("Height: \(fabWidth)")
        print("Width: \(fabHeight)")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor,constant: -10 * (width/375)).isActive = true
        stackView.topAnchor.constraint(equalTo: safeMargins.topAnchor,constant: 10).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: fabWidth).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: fabHeight*2+padding).isActive = true
        // Add even handlers to buttons
        homeScreenSettingsFAB.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
        homeScreenNotificationsFAB.addTarget(self, action:#selector(handleButtonPress), for: .touchUpInside)
    }
    
  @objc func handleButtonPress(sender: HomeScreenFAB){
      if sender.buttonName.rawValue == "Settings Button"{
            print("Settings button pressed")
        }
    
      else if sender.buttonName.rawValue == "Notifications Button" {
            print("notifications button pressed")
        }
    }
    
    @IBAction func presentHomeScreenMenu() {
       
        let homeScreenMenu = HomeScreenModalViewController()
        homeScreenMenu.modalPresentationStyle = .popover
        self.present(homeScreenMenu, animated: false)
    }
    @IBAction func presentHomeScreenMenu2() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeScreenMenu = storyboard.instantiateViewController(identifier: "HomeScreenModalViewController")
        homeScreenMenu.modalPresentationStyle = .popover
        self.present(homeScreenMenu, animated: false)
    }
    
    
}

