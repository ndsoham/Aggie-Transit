//
//  NotificationsScreenViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/4/22.
//

import Foundation
import UIKit

class NotificationsScreenViewController: UIViewController {
    private var tableSuperView: UIView?
    private var tableView: UITableView?
    private var stackView: UIStackView?
    private var navigationView: NavigationView?
    private var width: Double?
    private var height: Double?
    private var padding: Double?
    private var safeAreaHeight: Double?
    private var viewControllerMargins: UILayoutGuide?
    private var stackViewBottomMargin: Double?
    private var navigationViewWidth: Double?
    private var navigationViewHeight: Double?
    private var tableSuperViewWidth: Double?
    private var tableSuperViewHeight: Double?
    override func viewDidLoad() {
        layoutSubviews()
        super.viewDidLoad()
    }
    func layoutSubviews() {
        safeAreaHeight = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
        self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        if let safeAreaHeight = safeAreaHeight{
            width = self.view.frame.width
            height = self.view.frame.height - safeAreaHeight
            if let width = width, let height = height{
                padding = 10 * (812/height)
                if let padding = padding {
                    stackView = UIStackView()
                    if let stackView = stackView {

                        // configure the stackview
                        stackView.axis = .vertical
                        stackView.spacing = 5 * (812/height)
                        stackView.distribution = .fill
                        stackView.alignment = .center
                        stackView.isUserInteractionEnabled = true
                        stackView.translatesAutoresizingMaskIntoConstraints = false
                        // add to view hierarchy
                        self.view.addSubview(stackView)
                        // constrain the stack view
                        viewControllerMargins = self.view.safeAreaLayoutGuide
                        stackViewBottomMargin = padding
                        if let viewControllerMargins = viewControllerMargins, let stackViewBottomMargin = stackViewBottomMargin {
                            stackView.topAnchor.constraint(equalTo: viewControllerMargins.topAnchor).isActive = true
                            stackView.bottomAnchor.constraint(equalTo: viewControllerMargins.bottomAnchor, constant: -stackViewBottomMargin).isActive = true
                            stackView.leadingAnchor.constraint(equalTo: viewControllerMargins.leadingAnchor).isActive = true
                            stackView.trailingAnchor.constraint(equalTo: viewControllerMargins.trailingAnchor).isActive = true
                        }
                        // configure the navigation view
                        navigationViewWidth = width - padding
                        navigationViewHeight = 44 * (height/812)
                        
                        if let navigationViewWidth = navigationViewWidth, let navigationViewHeight = navigationViewHeight {
                            navigationView = NavigationView(frame: CGRect(x: 0, y: 0, width: navigationViewWidth, height: navigationViewHeight), screenName: "Notifications")

                            if let navigationView = navigationView {
                                // configure the navigation view
                                navigationView.translatesAutoresizingMaskIntoConstraints = false
                                navigationView.delegate = self
                                // constrain the navigation view
                                navigationView.widthAnchor.constraint(equalToConstant: navigationViewWidth).isActive = true
                                navigationView.heightAnchor.constraint(equalToConstant: navigationViewHeight).isActive = true
                                // add to view hierarchy
                                stackView.addArrangedSubview(navigationView)
                            }
                            // configure table super view
                            tableSuperViewWidth = navigationViewWidth - 16
                            tableSuperViewHeight = height - navigationViewHeight - padding
                            if let tableSuperViewWidth = tableSuperViewWidth, let tableSuperViewHeight = tableSuperViewHeight {
                                tableSuperView = UIView(frame: CGRect(x: 0, y: 0, width: tableSuperViewWidth, height: tableSuperViewHeight))
                                if let tableSuperView = tableSuperView {
                                    tableSuperView.layer.cornerRadius = 15
                                    tableSuperView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
                                    tableSuperView.layer.borderWidth = 2
                                    tableSuperView.translatesAutoresizingMaskIntoConstraints = false
                                    // constrain the table super view
                                    tableSuperView.widthAnchor.constraint(equalToConstant: tableSuperViewWidth).isActive = true
                                    // add the table super view to the view hierarchy
                                    stackView.addArrangedSubview(tableSuperView)
                                    // configure the table view
                                    tableView = UITableView(frame: CGRect(x: 0, y: 0, width: tableSuperViewWidth, height: tableSuperViewHeight))
                                    if let tableView = tableView{
                                        tableView.delegate = self
                                        tableView.dataSource = self
                                        tableView.layer.cornerRadius = 15
                                        tableView.translatesAutoresizingMaskIntoConstraints = false
                                        tableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                                        tableView.register(NotificationsScreenTableViewCell.self, forCellReuseIdentifier: "notificationsScreenViewControllerTableViewCell")
                                        tableView.allowsSelection = false
                                        tableView.separatorStyle = .none
                                        // add the table view to the view hierarchy
                                        tableSuperView.addSubview(tableView)
                                        // constrain the table view
                                        let tableSuperViewMargins = tableSuperView.safeAreaLayoutGuide
                                        tableView.leadingAnchor.constraint(equalTo: tableSuperViewMargins.leadingAnchor).isActive = true
                                        tableView.trailingAnchor.constraint(equalTo: tableSuperViewMargins.trailingAnchor).isActive = true
                                        tableView.topAnchor.constraint(equalTo: tableSuperViewMargins.topAnchor).isActive = true
                                        tableView.bottomAnchor.constraint(equalTo: tableSuperViewMargins.bottomAnchor).isActive = true
                                    }
                                
                                    
                                }
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
        self.dismiss(animated: false)
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
