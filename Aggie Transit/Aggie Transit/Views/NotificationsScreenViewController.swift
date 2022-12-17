//
//  NotificationsScreenViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/4/22.
//

import Foundation
import UIKit

class NotificationsScreenViewController: UIViewController {
    private var tableView: UITableView?
    private var width: Double?
    private var height: Double?
    private var padding: Double?
    private var safeAreaHeight: Double?
    private var viewControllerMargins: UILayoutGuide?
    private var tableViewWidth: Double?
    private var tableViewHeight: Double?
    private var navigationBar: UINavigationBar?
    override func viewDidLoad() {
        layoutSubviews()
        super.viewDidLoad()
    }
    func layoutSubviews() {
        // configure navigation bar
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = UIColor(named: "textColor")
            navigationBar.prefersLargeTitles = true
            navigationItem.title = "Notifications"
            let appearance = UINavigationBarAppearance()
            appearance.shadowColor = .clear
            appearance.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
            navigationItem.compactScrollEdgeAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            navigationItem.compactAppearance = appearance
            navigationItem.standardAppearance = appearance
        }
        safeAreaHeight = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
        self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        if let safeAreaHeight = safeAreaHeight {
            width = self.view.frame.width
            height = self.view.frame.height - safeAreaHeight
            if let width = width, let height = height{
                padding = 10 * (812/height)
                if let padding = padding {
                    tableViewWidth = width - padding*2
                    tableViewHeight = height - padding*2
                    if let tableViewWidth = tableViewWidth, let tableViewHeight = tableViewHeight {
                        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: tableViewHeight))
                        if let tableView = tableView {
                            // configure
                            tableView.delegate = self
                            tableView.dataSource = self
                            tableView.layer.cornerRadius = 15
                            tableView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
                            tableView.layer.borderWidth = 2
                            tableView.translatesAutoresizingMaskIntoConstraints = false
                            tableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                            tableView.allowsSelection = false
                            // register cell
                            tableView.register(NotificationsScreenTableViewCell.self, forCellReuseIdentifier: "notificationsScreenViewControllerTableViewCell")
                            // add to view hierarchy
                            self.view.addSubview(tableView)
                            // add constraints
                            viewControllerMargins = self.view.safeAreaLayoutGuide
                            if let viewControllerMargins = viewControllerMargins {
                                tableView.leadingAnchor.constraint(equalTo: viewControllerMargins.leadingAnchor,constant: padding).isActive = true
                                tableView.trailingAnchor.constraint(equalTo: viewControllerMargins.trailingAnchor,constant: -padding).isActive = true
                                tableView.topAnchor.constraint(equalTo: viewControllerMargins.topAnchor,constant: padding).isActive = true
                                tableView.bottomAnchor.constraint(equalTo: viewControllerMargins.bottomAnchor,constant: -padding).isActive = true
                            }
                        }
                    }
                }
            }
            
        }
        
    }
}

extension NotificationsScreenViewController: UITableViewDataSource, UITableViewDelegate, BackButtonDelegate{
    func handleBackButtonPressed() {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsScreenViewControllerTableViewCell") as! NotificationsScreenTableViewCell
        cell.notificationsHeaderText = "Notification"
        cell.notificationsTextContent = "Notification Content"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112.31
    }
   
    
    
    
}
