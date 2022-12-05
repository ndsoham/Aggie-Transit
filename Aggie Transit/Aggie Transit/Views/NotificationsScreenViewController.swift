//
//  NotificationsScreenViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/4/22.
//

import Foundation
import UIKit

class NotificationsScreenViewController: UIViewController {
//    let navigationView = NavigationView()
    let tableSuperView = UIView()
    let tableView = UITableView()
    let stackView = UIStackView()
    var navigationView: NavigationView?
    override func viewDidLoad() {
        layoutSubviews()
        tableView.dataSource = self
        tableView.delegate = self
        super.viewDidLoad()
    }
    func layoutSubviews() {
        navigationView = NavigationView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44 * (self.view.frame.height/812)), screenName: "Notifications")
        if let navigationView = navigationView{
            self.view.addSubview(navigationView)
            navigationView.delegate = self
            //
            navigationView.translatesAutoresizingMaskIntoConstraints = false
            let margins = self.view.safeAreaLayoutGuide
            navigationView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
            navigationView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
            navigationView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
            navigationView.heightAnchor.constraint(equalToConstant: 44 * (self.view.frame.height/812)).isActive = true
        }
        
    }
    
}

extension NotificationsScreenViewController: UITableViewDataSource, UITableViewDelegate, BackButtonDelegate{
    func handleBackButtonPressed() {
        print("im here")
        self.dismiss(animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NotificationsScreenTableViewCell()
    }
    
    
}
