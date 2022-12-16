//
//  HomeScreenMenuView.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/1/22.
//

import Foundation
import UIKit

class HomeScreenMenuView: UIView {
    var searchBar: UISearchBar?
    var recentsTableView: UITableView?
    var favoritesTableView: UITableView?
    var allRoutesTableView: UITableView?
    var scrollView: UIScrollView?
    var height: Double?
    var width: Double?
    var searchBarHeight: Double?
    var searchBarWidth: Double?
    var tableViewHeight: Double?
    var tableViewWidth: Double?
    var pageControllerHeight: Double?
    var pageControllerWidth: Double?
    var scrollViewHeight: Double?
    var scrollViewWidth: Double?
    var superViewStack: UIStackView?
    var tableViewStack: UIStackView?
    var tableViewStackHeight: Double?
    var tableViewStackWidth: Double?
    var scrollMargins: UILayoutGuide?
    var viewMargins: UILayoutGuide?
    var pageController: PageController?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews(){
        height = self.frame.height - self.safeAreaInsets.top - self.safeAreaInsets.bottom
        width = self.frame.width
        self.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        self.isUserInteractionEnabled = true
        if let height = height, let width = width {
            // configure search bar
            searchBarHeight = 52 * (height/200)
            searchBarWidth = width
            if let searchBarHeight = searchBarHeight, let searchBarWidth = searchBarWidth {
                searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: searchBarWidth, height: searchBarHeight))
                if let searchBar = searchBar {
                    searchBar.placeholder = "Memorial Student Center (MSC)"
                    searchBar.searchBarStyle = .minimal
                    searchBar.translatesAutoresizingMaskIntoConstraints = false
                    if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                        if let borderColor = UIColor(named: "borderColor") {
                            searchField.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                            searchField.layer.borderColor = borderColor.cgColor
                            searchField.layer.borderWidth = 2
                            searchField.layer.cornerRadius = 18
                            searchBar.isTranslucent = false
                        }
                    }
                    
                    // constrain the search bar
                    searchBar.widthAnchor.constraint(equalToConstant: searchBarWidth).isActive = true
                    searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight).isActive = true
                    // configure the page controller
                    pageControllerHeight = 38 * (height/200)
                    pageControllerWidth = width
                    if let pageControllerHeight = pageControllerHeight, let pageControllerWidth = pageControllerWidth {
                        pageController = PageController(frame: CGRect(x: 0,y: 0,width: pageControllerWidth,height: pageControllerHeight))
                        if let pageController = pageController{
                            pageController.translatesAutoresizingMaskIntoConstraints = false
                            pageController.delegate = self
                            pageController.isUserInteractionEnabled = true
                            // constrain the page controller
                            pageController.widthAnchor.constraint(equalToConstant: pageControllerWidth).isActive = true
                            pageController.heightAnchor.constraint(equalToConstant: pageControllerHeight).isActive = true
                            // configure the scroll view
                            scrollViewHeight = height - pageControllerHeight - searchBarHeight
                            scrollViewWidth = width
                            if let scrollViewHeight = scrollViewHeight, let scrollViewWidth = scrollViewWidth {
                                scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
                                if let scrollView = scrollView {
                                    scrollView.contentSize = CGSize(width: scrollViewWidth*3, height: scrollViewHeight)
                                    scrollView.translatesAutoresizingMaskIntoConstraints = false
                                    scrollView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                                    scrollView.showsVerticalScrollIndicator = false
                                    scrollView.showsHorizontalScrollIndicator = false
                                    scrollView.isDirectionalLockEnabled = true
                                    scrollView.isPagingEnabled = true
                                    scrollView.delegate = pageController
                                    // constrain the scroll view
                                    scrollView.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true
                                    scrollView.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true
                                    // configure the table views
                                    tableViewHeight = height - pageControllerHeight - searchBarHeight
                                    tableViewWidth = width
                                    if let tableViewHeight = tableViewHeight, let tableViewWidth = tableViewWidth {
                                        recentsTableView = UITableView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: tableViewHeight))
                                        favoritesTableView = UITableView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: tableViewHeight))
                                        allRoutesTableView = UITableView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: tableViewHeight))
                                        if let recentsTableView = recentsTableView, let favoritesTableView = favoritesTableView, let allRoutesTableView = allRoutesTableView {
                                            // register the cell
                                            recentsTableView.register(HomeScreenModalTableViewCell.self, forCellReuseIdentifier: "homeScreenModalTableViewCell")
                                            favoritesTableView.register(HomeScreenModalTableViewCell.self, forCellReuseIdentifier: "homeScreenModalTableViewCell")
                                            allRoutesTableView.register(HomeScreenModalTableViewCell.self, forCellReuseIdentifier: "homeScreenModalTableViewCell")
                                            // configure the recents table view
                                            recentsTableView.dataSource = self
                                            recentsTableView.delegate = self
                                            recentsTableView.translatesAutoresizingMaskIntoConstraints = false
                                            recentsTableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                                            recentsTableView.rowHeight = 122
                                            recentsTableView.separatorStyle = .none
                                            recentsTableView.allowsSelection = false
                                            // constrain the recents table view
                                            recentsTableView.widthAnchor.constraint(equalToConstant: tableViewWidth).isActive = true
                                            recentsTableView.heightAnchor.constraint(equalToConstant: tableViewHeight).isActive = true
                                            // configure the favorites table view
                                            favoritesTableView.dataSource = self
                                            favoritesTableView.delegate = self
                                            favoritesTableView.translatesAutoresizingMaskIntoConstraints = false
                                            favoritesTableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                                            favoritesTableView.rowHeight = 122
                                            favoritesTableView.separatorStyle = .none
                                            favoritesTableView.allowsSelection = false
                                            // constrain the favorites table view
                                            favoritesTableView.widthAnchor.constraint(equalToConstant: tableViewWidth).isActive = true
                                            favoritesTableView.heightAnchor.constraint(equalToConstant: tableViewHeight).isActive = true
                                            // configure the all routes table view
                                            allRoutesTableView.dataSource = self
                                            allRoutesTableView.delegate = self
                                            allRoutesTableView.translatesAutoresizingMaskIntoConstraints = false
                                            allRoutesTableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                                            allRoutesTableView.rowHeight = 122
                                            allRoutesTableView.separatorStyle = .none
                                            allRoutesTableView.allowsSelection = false
                                            // constrain the all routes table view
                                            allRoutesTableView.widthAnchor.constraint(equalToConstant: tableViewWidth).isActive = true
                                            allRoutesTableView.heightAnchor.constraint(equalToConstant: tableViewHeight).isActive = true
                                            // configure the table stackview
                                            tableViewStackWidth = width
                                            tableViewStackHeight = scrollViewHeight
                                            if let tableViewStackWidth = tableViewStackWidth, let tableViewStackHeight = tableViewStackHeight {
                                                tableViewStack = UIStackView(frame: CGRect(x: 0, y: 0, width: tableViewStackWidth, height: tableViewStackHeight))
                                                if let tableViewStack = tableViewStack {
                                                    tableViewStack.axis = .horizontal
                                                    tableViewStack.distribution = .fill
                                                    tableViewStack.alignment = .leading
                                                    tableViewStack.translatesAutoresizingMaskIntoConstraints = false
                                                    
                                                    // add the table view stack
                                                    scrollView.addSubview(tableViewStack)
                                                    // constrain the table stack view
                                                    scrollMargins = scrollView.contentLayoutGuide
                                                    if let scrollMargins = scrollMargins{
                                                        tableViewStack.leadingAnchor.constraint(equalTo: scrollMargins.leadingAnchor).isActive = true
                                                        tableViewStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
                                                        tableViewStack.topAnchor.constraint(equalTo: scrollMargins.topAnchor).isActive = true
                                                        tableViewStack.bottomAnchor.constraint(equalTo: scrollMargins.bottomAnchor).isActive = true
                                                    }
                                                    // add the table views to the stack view
                                                    tableViewStack.addArrangedSubview(recentsTableView)
                                                    tableViewStack.addArrangedSubview(favoritesTableView)
                                                    tableViewStack.addArrangedSubview(allRoutesTableView)
                                                    // configure the super table view
                                                   
                                                    superViewStack = UIStackView(arrangedSubviews: [searchBar, pageController, scrollView])
                                                    if let superViewStack = superViewStack{
                                                        superViewStack.axis = .vertical
                                                        superViewStack.spacing = 0
                                                        superViewStack.alignment = .top
                                                        superViewStack.distribution = .fill
                                                        superViewStack.isUserInteractionEnabled = true
                                                        superViewStack.translatesAutoresizingMaskIntoConstraints = false
                                                        // add the super view stack to the hierarchy
                                                        self.addSubview(superViewStack)
                                                        // constrain the super view stack
                                                        viewMargins = self.safeAreaLayoutGuide
                                                        if let viewMargins = viewMargins{
                                                            superViewStack.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor).isActive = true
                                                            superViewStack.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor).isActive = true
                                                            superViewStack.topAnchor.constraint(equalTo: viewMargins.topAnchor).isActive = true
                                                           
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
                    
                    
                }
            }
        }
    }
}
extension HomeScreenMenuView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
                if tableView == allRoutesTableView {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenModalTableViewCell") as! HomeScreenModalTableViewCell
                    cell.icon = "01"
                    cell.text = "Bonfire"
                    cell.cellColor = .bonfirePurple
                    return cell
                }
                else if tableView == favoritesTableView {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenModalTableViewCell") as! HomeScreenModalTableViewCell
                    cell.icon = "⭐️"
                    cell.text = "Favorite Location"
                    cell.cellColor = .favoriteLocationGold
                    return cell
                }
                else if tableView == recentsTableView {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenModalTableViewCell") as! HomeScreenModalTableViewCell
                    cell.icon = "📍"
                    cell.text = "Recent Location"
                    cell.cellColor = .recentLocationRed
                    return cell
                }
            
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
}


extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
}

extension HomeScreenMenuView: PageControllerDelegate {
    func handlePageChanged(sender: UIButton) {
        if let scrollView = scrollView {
            let xPos = scrollView.frame.width * Double(sender.tag)
            let yPos = 0.0
            scrollView.scrollRectToVisible(CGRect(x: xPos, y: yPos, width: scrollView.frame.width, height: scrollView.frame.height), animated: true)
        }
    }
    
    
}
