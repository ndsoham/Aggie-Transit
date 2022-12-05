//
//  SettingsScreenViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/4/22.
//

import Foundation
import UIKit

class SettingsScreenViewController: UIViewController {
    var navigationView: NavigationView?
    var searchBar: UISearchBar?
    var tableSuperView: UIView?
    var tableView: UITableView?
    let stackView = UIStackView()
    var width: Double?
    var height: Double?
    var padding: Double?
    var safeAreaHeight: Double?
    var viewControllerMargins: UILayoutGuide?
    var stackViewBottomMargin: Double?
    
    override func viewDidLoad() {
        layoutSubviews()
        super.viewDidLoad()
    }
    func layoutSubviews(){
        safeAreaHeight = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
        if let safeAreaHeight = safeAreaHeight{
            width = self.view.frame.width
            height = self.view.frame.height - safeAreaHeight
            if let width = width, let height = height{
                padding = 10 * (812/height)
                if let padding = padding{
                    // configure the stackview
                    stackView.axis = .vertical
                    stackView.spacing = 5 * (812/height)
                    stackView.distribution = .fill
                    stackView.alignment = .center
                    stackView.isUserInteractionEnabled = true
                    stackView.translatesAutoresizingMaskIntoConstraints = false
                    stackView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                    // add stackview to the view hierarchy
                    self.view.addSubview(stackView)
                    // constrain the stackview
                    viewControllerMargins = self.view.safeAreaLayoutGuide
                    stackViewBottomMargin = padding
                    if let viewControllerMargins = viewControllerMargins, let stackViewBottomMargin = stackViewBottomMargin{
                        stackView.topAnchor.constraint(equalTo: viewControllerMargins.topAnchor).isActive = true
                        stackView.bottomAnchor.constraint(equalTo: viewControllerMargins.bottomAnchor,constant: -stackViewBottomMargin).isActive = true
                        stackView.leadingAnchor.constraint(equalTo: viewControllerMargins.leadingAnchor).isActive = true
                        stackView.trailingAnchor.constraint(equalTo: viewControllerMargins.trailingAnchor).isActive = true
                    }
                    // configure the navigation view
                    let navigationViewWidth = width - padding
                    let navigationViewHeight = 44 * (height/812)
                    navigationView = NavigationView(frame: CGRect(x: 0, y: 0, width: navigationViewWidth, height: navigationViewHeight), screenName: "Settings")
                    guard let navigationView = navigationView else {return}
                    navigationView.frame = CGRect(x: 0, y: 0, width: navigationViewWidth, height: navigationViewHeight)
                    navigationView.translatesAutoresizingMaskIntoConstraints = false
                    navigationView.delegate = self
                    // constrain the navigation view
                    navigationView.widthAnchor.constraint(equalToConstant: navigationViewWidth).isActive = true
                    navigationView.heightAnchor.constraint(equalToConstant: navigationViewHeight).isActive = true
                    // add navigation view to the stackview
                    stackView.addArrangedSubview(navigationView)
                    // configure the searchbar
                    let searchBarWidth = width - padding
                    let searchBarHeight = 52 * (812/height)
                    searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: searchBarWidth, height: searchBarHeight))
                    if let searchBar = searchBar{
                        searchBar.searchTextField.placeholder = "Settings"
                        searchBar.searchBarStyle = .minimal
                        searchBar.translatesAutoresizingMaskIntoConstraints = false
                        if let searchField = searchBar.value(forKey: "searchField") as? UITextField{
                            if let borderColor = UIColor(named: "borderColor") {
                                searchField.layer.borderColor = borderColor.cgColor
                                searchField.layer.borderWidth = 2
                                searchField.layer.cornerRadius = 15
                            }
                            
                        }
                        // constrain the searchbar
                        searchBar.widthAnchor.constraint(equalToConstant: searchBarWidth).isActive = true
                        searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight).isActive = true
                        // add the searchbar to the view hierarchy
                        stackView.addArrangedSubview(searchBar)
                    }
                    // configure table superview
                    let tableSuperViewWidth = searchBarWidth
                    let tableSuperViewHeight = height - searchBarHeight - navigationViewHeight - padding
                    tableSuperView = UIView(frame: CGRect(x: 0, y: 0, width: tableSuperViewWidth, height: tableSuperViewHeight))
                    if let tableSuperView = tableSuperView{
                        tableSuperView.layer.cornerRadius = 15
                        tableSuperView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
                        tableSuperView.layer.borderWidth = 2
                        tableSuperView.translatesAutoresizingMaskIntoConstraints = false
                        // constrain the table superview
                        tableSuperView.widthAnchor.constraint(equalToConstant: tableSuperViewWidth).isActive = true
//                        tableSuperView.heightAnchor.constraint(equalToConstant: tableSuperViewHeight).isActive = true
                        // add the table super view to the view hierarchy
                        stackView.addArrangedSubview(tableSuperView)
                        // configure the table view
                        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: tableSuperViewWidth, height: tableSuperViewHeight))
                        if let tableView = tableView{
                            tableView.delegate = self
                            tableView.dataSource = self
                            tableView.layer.cornerRadius = 15
                            tableView.translatesAutoresizingMaskIntoConstraints = false
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

extension SettingsScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.frame.height
        return 57.5 * (812/height)
    }
    
    
}

extension SettingsScreenViewController: BackButtonDelegate {
    func handleBackButtonPressed() {
        self.dismiss(animated: false)
    }
    
    
}
