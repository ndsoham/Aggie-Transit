////
////  HomeScreenModalViewController.swift
////  Aggie Transit
////
////  Created by Soham Nagawanshi on 11/4/22.
////
//
//import Foundation
//import UIKit
//
//class HomeScreenModalViewController: UIViewController {
//    var recentsTableView: UITableView = UITableView()
//    var favoritesTableView: UITableView = UITableView()
//    var allRoutesTableView: UITableView = UITableView()
//    var testScroll: UIScrollView = UIScrollView()
//    var testPage: PageController?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        layoutSubviews()
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        
//    }
//    func layoutSubviews() {
//        self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//        let height = self.view.frame.height
//        let width = self.view.frame.width
//        // Scale height and width appropriately and configure search bar
//        let searchBarHeight = height * (52/812)
//        let searchBarWidth = width
//        // configure searchbar
//        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: searchBarWidth, height: searchBarHeight))
//        searchBar.searchTextField.placeholder = "Memorial Student Center (MSC)"
//        searchBar.searchBarStyle = .minimal
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchBar.widthAnchor.constraint(equalToConstant: searchBarWidth).isActive = true
//        searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight).isActive = true
//        if let searchField = searchBar.value(forKey: "searchField") as? UITextField{
//            if let borderColor = UIColor(named: "borderColor") {
//                searchField.layer.borderColor = borderColor.cgColor
//                searchField.layer.borderWidth = 2
//                searchField.layer.cornerRadius = 18
//                searchBar.isTranslucent = false
//            }
//        }
//        // create recents view
//        let tableViewHeight = Int(height - searchBarHeight - 20)
//        let tableViewWidth = Int(searchBarWidth)
//        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: tableViewHeight), style: .plain)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.widthAnchor.constraint(equalToConstant: CGFloat(tableViewWidth)).isActive = true
//        tableView.heightAnchor.constraint(equalToConstant: CGFloat(tableViewHeight)).isActive = true
//        tableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//        recentsTableView = tableView
//        // create favorites table view
//        let tableView2 = UITableView(frame: CGRect(x: 0 + tableViewWidth, y: 0, width: tableViewWidth, height: tableViewHeight), style: .plain)
//        favoritesTableView = tableView2
//        tableView2.dataSource = self
//        tableView2.delegate = self
//        tableView2.translatesAutoresizingMaskIntoConstraints = false
//        tableView2.widthAnchor.constraint(equalToConstant: CGFloat(tableViewWidth)).isActive = true
//        tableView2.heightAnchor.constraint(equalToConstant: CGFloat(tableViewHeight)).isActive = true
//        tableView2.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//        // create all routes table view
//        let tableView3 = UITableView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: tableViewHeight), style: .plain)
//        allRoutesTableView = tableView3
//        tableView3.dataSource = self
//        tableView3.delegate = self
//        tableView3.translatesAutoresizingMaskIntoConstraints = false
//        tableView3.widthAnchor.constraint(equalToConstant: CGFloat(tableViewWidth)).isActive = true
//        tableView3.heightAnchor.constraint(equalToConstant: CGFloat(tableViewHeight)).isActive = true
//        tableView3.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//        
//        // test out custom pageControl
//        let pageControlHeight = height * (38/812)
//        let pageControlWidth = searchBarWidth
//        let pageController = PageController(frame: CGRect(x: 0, y: 0, width: pageControlWidth, height: pageControlHeight), numPages: 3, pageNames: ["Recents","Favorites","All Routes"])
//        testPage = pageController
//        pageController.translatesAutoresizingMaskIntoConstraints = false
//        pageController.widthAnchor.constraint(equalToConstant: pageControlWidth).isActive = true
//        pageController.heightAnchor.constraint(equalToConstant: pageControlHeight).isActive = true
//        pageController.isUserInteractionEnabled = true
//        pageController.delegate = self
//        // Create and configure scrollview and add constraints to the table views
//        let scrollViewHeight = height - searchBarHeight - pageControlHeight
//        let scrollViewWidth = pageControlWidth
//        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
//        testScroll = scrollView
//        scrollView.contentSize = CGSize(width: scrollViewWidth*3, height: scrollViewHeight)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true
//        scrollView.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true
//        scrollView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.isDirectionalLockEnabled = true
//        scrollView.isPagingEnabled = true
//        scrollView.delegate = self
//        // try the stackview method
//        let tableStackViewWidth = scrollViewWidth
//        let tableStackViewHeight = scrollViewHeight
//        let tableStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: tableStackViewWidth, height: tableStackViewHeight))
//        tableStackView.axis = .horizontal
//        tableStackView.distribution = .fillEqually
//        tableStackView.alignment = .leading
//        // add the table stack to the scroll view hierarchy
//        scrollView.addSubview(tableStackView)
//        // give the tableview constraints
//        let scrollMargins = scrollView.contentLayoutGuide
//        tableStackView.leadingAnchor.constraint(equalTo: scrollMargins.leadingAnchor).isActive = true
//        tableStackView.trailingAnchor.constraint(equalTo: scrollMargins.trailingAnchor).isActive = true
//        tableStackView.topAnchor.constraint(equalTo: scrollMargins.topAnchor).isActive = true
//        tableStackView.bottomAnchor.constraint(equalTo: scrollMargins.bottomAnchor).isActive = true
//        tableStackView.translatesAutoresizingMaskIntoConstraints = false
//        // configure stack view for entire modal
//        let stackview = UIStackView(arrangedSubviews: [searchBar,pageController,scrollView])
//        stackview.axis = .vertical
//        stackview.spacing = 0
//        stackview.alignment = .top
//        stackview.distribution = .fill
//        stackview.isUserInteractionEnabled = true
//        tableStackView.addArrangedSubview(tableView)
//        tableStackView.addArrangedSubview(tableView2)
//        tableStackView.addArrangedSubview(tableView3)
//        // add stack view to the view hierarchy
//        self.view.addSubview(stackview)
//        // add constraints to the stack view
//        let margins = self.view.safeAreaLayoutGuide
//        stackview.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
//        stackview.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
//        stackview.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
////        stackview.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
//        stackview.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//    }
//  
//}
//
//extension HomeScreenModalViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if tableView == allRoutesTableView {
//            let cell = HomeScreenModalTableViewCell(style: .default, reuseIdentifier: "homeScreenModalTableViewCell", icon: "01", text: "Bonfire", cellColor: .bonfirePurple)
//            return cell
//        }
//        else if tableView == favoritesTableView {
//            let cell = HomeScreenModalTableViewCell(style: .default, reuseIdentifier: "homeScreenModalTableViewCell", icon: "⭐️", text: "Favorite Location", cellColor: .favoriteLocationGold)
//            return cell
//        }
//        else if tableView == recentsTableView {
//            let cell = HomeScreenModalTableViewCell(style: .default, reuseIdentifier: "homeScreenModalTableViewCell", icon: "📍", text: "Recent Location", cellColor: .recentLocationRed)
//            return cell
//        }
//        
//        return UITableViewCell()
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        // going to keep height constant for all phones
//        return 122
//    }
//}
//
//extension HomeScreenModalViewController: PageControllerDelegate {
//    func handlePageChanged(sender: UIButton) {
//        let pageNumber = sender.tag
//        let height = self.view.frame.height
//        let width = self.view.frame.width
//        let searchBarHeight = height * (52/812)
//        let searchBarWidth = width
//        let pageControlHeight = height * (38/812)
//        let pageControlWidth = searchBarWidth
//        let scrollViewHeight = height - searchBarHeight - pageControlHeight
//        let scrollViewWidth = pageControlWidth
//        testScroll.scrollRectToVisible(CGRect(x: 0 + CGFloat(pageNumber)*searchBarWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight), animated: true)
//    }
//    
//    
//}
//
//extension HomeScreenModalViewController: UIScrollViewDelegate {
//   
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let cp = Int(floor(scrollView.contentOffset.x/scrollView.frame.size.width))
//        if let testPage = testPage {
//            if   (cp == 0 || cp == 1 || cp == 2) {
//                testPage.currentPage = testPage.pages[cp]
//            }
//        }
//        
//    }
//   
//}
//
//
//
//
