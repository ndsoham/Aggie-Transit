//
//  HomeScreenViewController+Buttons.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/28/23.
//

import Foundation
import UIKit

//MARK: - handle button actions
extension HomeScreenViewController {
    @objc func notiButtonPressed() {
        print("noti pressed")
    }
    
    @objc func busButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let busListVC = storyboard.instantiateViewController(withIdentifier: "BusListScreenViewController")
        busListVC.modalPresentationStyle = .overCurrentContext
        dismiss(animated: false)
        present(busListVC, animated: true)
    }
    
    @objc func favButtonPressed() {
        print("fav pressed")
    }
    
    @objc func userButtonPressed() {
        print("user pressed")
    }
}
