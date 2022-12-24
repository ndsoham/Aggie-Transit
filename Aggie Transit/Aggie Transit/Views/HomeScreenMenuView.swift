//
//  HomeScreenMenuView.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/1/22.
//

import Foundation
import UIKit
import MapKit
protocol PathMakerDelegate {
    func didGatherStopCoordinates(stops: [CLLocationCoordinate2D])
}

class HomeScreenMenuView: UIView {
    private var searchBar: UISearchBar?
    private var recentsTableView: UITableView?
    private var favoritesTableView: UITableView?
    private var allRoutesTableView: UITableView?
    private var scrollView: UIScrollView?
    private var height: Double?
    private var width: Double?
    private var searchBarHeight: Double?
    private var searchBarWidth: Double?
    private var tableViewHeight: Double?
    private var tableViewWidth: Double?
    private var pageControllerHeight: Double?
    private var pageControllerWidth: Double?
    private var scrollViewHeight: Double?
    private var scrollViewWidth: Double?
    private var superViewStack: UIStackView?
    private var tableViewStack: UIStackView?
    private var tableViewStackHeight: Double?
    private var tableViewStackWidth: Double?
    private var scrollMargins: UILayoutGuide?
    private var viewMargins: UILayoutGuide?
    private var pageController: UISegmentedControl?
    private var stackViewSpacing: Double?
    private var dataGatherer: DataGatherer?
    private var onCampusRoutes: [BusRoute]?
    private var offCampusRoutes: [BusRoute]?
    private var programmedScroll: Bool = false
    public var pathDelegate: PathMakerDelegate?
    private var grabber: UIView?
    private var grabberHeight: Double?
    private var grabberWidth: Double?
    override init(frame: CGRect){
        super.init(frame: frame)
        layoutSubviews()
        dataGatherer = DataGatherer()
        if let dataGatherer = dataGatherer {
            dataGatherer.delegate = self
            dataGatherer.gatherData(endpoint: "Routes")
        }
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews(){
        height = self.frame.height - self.safeAreaInsets.top - self.safeAreaInsets.bottom
        width = self.frame.width
        self.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 15
        if let height = height, let width = width {
            // create a grabber
           grabberHeight = 5
            grabberWidth = 50
            if let grabberHeight = grabberHeight, let grabberWidth = grabberWidth{
                grabber = UIView(frame: CGRect(x: 0, y: 0, width: grabberWidth, height: grabberHeight))
                if let grabber = grabber{
                    // configure the grabber
                    grabber.backgroundColor = .lightGray
                    grabber.alpha = 0.5
                    grabber.layer.cornerRadius = 3
                    // constrain the grabber
                    grabber.widthAnchor.constraint(equalToConstant: grabberWidth).isActive = true
                    grabber.heightAnchor.constraint(equalToConstant: grabberHeight).isActive = true
                    // configure search bar
                    searchBarHeight = 52 * (height/(812/3))
                    searchBarWidth = width
                    if let searchBarHeight = searchBarHeight, let searchBarWidth = searchBarWidth {
                        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: searchBarWidth, height: searchBarHeight))
                        if let searchBar = searchBar {
                            searchBar.placeholder = "Memorial Student Center (MSC)"
                            searchBar.searchBarStyle = .minimal
                            searchBar.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                            searchBar.translatesAutoresizingMaskIntoConstraints = false
                            if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                                searchField.textColor = UIColor(named: "textColor")
                                searchField.layer.borderWidth = 2
                                searchField.clipsToBounds = true
                                searchField.layer.cornerRadius = 18
                                searchField.layer.borderColor = UIColor(named: "borderColor")?.cgColor
                            }
                            
                            // constrain the search bar
                            searchBar.widthAnchor.constraint(equalToConstant: searchBarWidth).isActive = true
                            searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight).isActive = true
                            // configure the page controller
                            pageControllerHeight = 30 * (height/(812/3))
                            pageControllerWidth = width - 16
                            if let pageControllerHeight = pageControllerHeight, let pageControllerWidth = pageControllerWidth {
                                pageController = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: pageControllerWidth, height: pageControllerHeight))
                                if let pageController = pageController{
                                    pageController.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                                    pageController.insertSegment(withTitle: "Recents", at: 0, animated: false)
                                    pageController.insertSegment(withTitle: "Favorites", at: 1, animated: false)
                                    pageController.insertSegment(withTitle: "All Routes", at: 2, animated: false)
                                    pageController.selectedSegmentIndex = 0
                                    pageController.translatesAutoresizingMaskIntoConstraints = false
                                    pageController.isUserInteractionEnabled = true
                                    pageController.addTarget(self, action: #selector(handleControlPageChanged), for: .valueChanged)
                                    // constrain the page controller
                                    pageController.widthAnchor.constraint(equalToConstant: pageControllerWidth).isActive = true
                                    pageController.heightAnchor.constraint(equalToConstant: pageControllerHeight).isActive = true
                                    // configure the scroll view
                                    scrollViewHeight = height - pageControllerHeight - searchBarHeight - grabberHeight
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
                                                    allRoutesTableView.allowsMultipleSelection = false
                                                    allRoutesTableView.allowsSelection = true
                                                    allRoutesTableView.dataSource = self
                                                    allRoutesTableView.delegate = self
                                                    allRoutesTableView.translatesAutoresizingMaskIntoConstraints = false
                                                    allRoutesTableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                                                    allRoutesTableView.rowHeight = 122
                                                    allRoutesTableView.separatorStyle = .none
                                                    
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
                                                           
                                                            superViewStack = UIStackView(arrangedSubviews: [grabber, searchBar, pageController, scrollView])
                                                            stackViewSpacing = 4.0 * (height/(812/3))
                                                            if let superViewStack = superViewStack, let stackViewSpacing = stackViewSpacing{
                                                                superViewStack.axis = .vertical
                                                                superViewStack.spacing = stackViewSpacing
                                                                superViewStack.alignment = .center
                                                                superViewStack.distribution = .equalSpacing
                                                                superViewStack.isUserInteractionEnabled = true
                                                                superViewStack.translatesAutoresizingMaskIntoConstraints = false
                                                                // add the super view stack to the hierarchy
                                                                self.addSubview(superViewStack)
                                                                // constrain the super view stack
                                                                viewMargins = self.safeAreaLayoutGuide
                                                                if let viewMargins = viewMargins{
                                                                    superViewStack.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor).isActive = true
                                                                    superViewStack.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor).isActive = true
                                                                    superViewStack.topAnchor.constraint(equalTo: viewMargins.topAnchor, constant: 8).isActive = true
                                                                   
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
    }
}
//MARK: - Provide Table View with data
extension HomeScreenMenuView: UITableViewDataSource {
    // provide the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == allRoutesTableView {
            return 2
        }
        else if tableView == recentsTableView {
            return 1
        }
        else if tableView == favoritesTableView {
            return 1
        }
        return -1
    }
    // provide the title for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == allRoutesTableView {
            if section == 0 {
                return "On-Campus"
            }
            else {
                return "Off-Campus"
            }
        }
        else {
            return "On-Campus"
        }
    }
    // provide number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == allRoutesTableView {
            if section == 0 {
                if let onCampusRoutes = self.onCampusRoutes {
                    return onCampusRoutes.count
                }
            }
            else if section == 1 {
                if let offCampusRoutes = self.offCampusRoutes {
                    return offCampusRoutes.count
                }
            }
        }
        else if tableView == favoritesTableView {
            return 10
        }
        else if tableView == recentsTableView {
            return 10
        }
        return -1
    }
    // provide a cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == allRoutesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenModalTableViewCell") as! HomeScreenModalTableViewCell
            if let onCampusRoutes = onCampusRoutes, let offCampusRoutes = offCampusRoutes {
                if indexPath.section == 0 {
                    cell.icon = onCampusRoutes[indexPath.row].number
                    cell.text = onCampusRoutes[indexPath.row].name
                    cell.cellColor = onCampusRoutes[indexPath.row].color
                    return cell
                }
                else if indexPath.section == 1 {
                    cell.icon = offCampusRoutes[indexPath.row].number
                    cell.text = offCampusRoutes[indexPath.row].name
                    cell.cellColor = offCampusRoutes[indexPath.row].color
                    return cell
                }
            }
        }
        else if tableView == favoritesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenModalTableViewCell") as! HomeScreenModalTableViewCell
            cell.icon = "⭐️"
            cell.text = "Favorite Location"
            cell.cellColor = UIColor(named: cellBackgroundColor.favoriteLocationGold.rawValue)
            return cell
        }
        else if tableView == recentsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenModalTableViewCell") as! HomeScreenModalTableViewCell
            cell.icon = "📍"
            cell.text = "Recent Location"
            cell.cellColor = UIColor(named: cellBackgroundColor.recentLocationRed.rawValue)
            return cell
        }
        
        
        return UITableViewCell()
    }
    // provide a height for each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
}
//MARK: - Conform to Table View's Delegate
extension HomeScreenMenuView: UITableViewDelegate {
    // manage selection of rows
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == allRoutesTableView {
            if indexPath.section == 0 {
                if let onCampusRoutes = onCampusRoutes, let dataGatherer = dataGatherer {
                    var endpoint = "route/{route}/pattern"
                    endpoint = endpoint.replacingOccurrences(of: "{route}", with: onCampusRoutes[indexPath.row].number)
                    dataGatherer.gatherData(endpoint: endpoint)
                }
            }
            else if indexPath.section == 1 {
                if let offCampusRoutes = offCampusRoutes, let dataGatherer = dataGatherer {
                    var endpoint = "route/{route}/pattern"
                    endpoint = endpoint.replacingOccurrences(of: "{route}", with: offCampusRoutes[indexPath.row].number)
                    dataGatherer.gatherData(endpoint: endpoint)
                }
            }
        }
    }
}
//MARK: - Handle Page Control Page Changed
extension HomeScreenMenuView {
    @objc func handleControlPageChanged(sender: UISegmentedControl){
        if let scrollView = scrollView {
            let xPos = scrollView.frame.width * Double(sender.selectedSegmentIndex)
            let yPos = 0.0
            self.programmedScroll = true
            UIView.animate(withDuration: 0.3) {
                scrollView.scrollRectToVisible(CGRect(x: xPos, y: yPos, width: scrollView.frame.width, height: scrollView.frame.height), animated: false)
            } completion: { _ in
                self.programmedScroll = false
            }

        }
    }
}
//MARK: - Handle Data Gathering/ etc.
extension HomeScreenMenuView: DataGathererDelegate {
    func didGatherBusPattern(points: [BusPattern]) {
        var stopPoints: [CLLocationCoordinate2D] = []
        for point in points {
            let latitude = CoordinateConverter(latitude: point.latitude, longitude: point.longitude).0
            let longitude = CoordinateConverter(latitude: point.latitude, longitude: point.longitude).1
            let point = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            stopPoints.append(point)
        }
        self.pathDelegate?.didGatherStopCoordinates(stops: stopPoints)
        
    }
    
    func didGatherBusRoutes(onCampusRoutes: [BusRoute], offCampusRoutes: [BusRoute]) {
        self.onCampusRoutes = onCampusRoutes
        self.offCampusRoutes = offCampusRoutes
        DispatchQueue.main.async {
            self.allRoutesTableView?.reloadData()
        }
        
    }
    
    
}
