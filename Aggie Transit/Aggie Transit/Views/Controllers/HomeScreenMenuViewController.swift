//
//  HomeScreenMenuView.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/1/22.
//

import Foundation
import UIKit
import MapKit
import DropDown
protocol LocationIdentifierDelegate {
    func showLocationOnMap(results: [Location])
}
class HomeScreenMenuViewController: UIViewController {
    public var searchBar: UISearchBar?
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
    private var dataGatherer: DataGatherer = DataGatherer()
    private var onCampusRoutes: [BusRoute]?
    private var offCampusRoutes: [BusRoute]?
    private var programmedScroll: Bool = false
    public var pathDelegate: PathMakerDelegate?
    public var locationIdentifierDelegate: LocationIdentifierDelegate?
    private var editingNotification: Notification?
    private var collapseNotification: Notification?
    public var map: MKMapView?
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchResults: DropDown?
    private var cellNib: UINib?
    private var addresses: [String] = []
    private var options: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
        setUpDataGatherer()
    }
    
    func layoutSubviews(){
        height = self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom
        width = self.view.frame.width
        self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        self.view.isUserInteractionEnabled = true
        self.view.layer.cornerRadius = 15
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    if let height = height, let width = width {
                // configure search bar
                searchBarHeight = 52 * (height/812)
                searchBarWidth = width - 16
                if let searchBarHeight = searchBarHeight, let searchBarWidth = searchBarWidth {
                    searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: searchBarWidth, height: searchBarHeight))
                    if let searchBar = searchBar {
                        searchBar.placeholder = "Memorial Student Center (MSC)"
                        searchBar.searchBarStyle = .minimal
                        searchBar.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                        searchBar.translatesAutoresizingMaskIntoConstraints = false
                        searchBar.delegate = self
                        searchBar.showsCancelButton = false
                        searchBar.tintColor = .systemBlue
                        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                            searchField.textColor = UIColor(named: "textColor")
                            searchField.clipsToBounds = true
                        }
                        // constrain the search bar
                        searchBar.widthAnchor.constraint(equalToConstant: searchBarWidth).isActive = true
                        searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight).isActive = true
                        // configure the page controller
                        pageControllerHeight = 30 * (height/812)
                        pageControllerWidth = searchBarWidth - 16
                        if let pageControllerHeight = pageControllerHeight, let pageControllerWidth = pageControllerWidth {
                            pageController = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: pageControllerWidth, height: pageControllerHeight))
                            if let pageController = pageController{
                                pageController.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                                pageController.insertSegment(withTitle: "Recents", at: 0, animated: false)
                                pageController.insertSegment(withTitle: "Favorites", at: 1, animated: false)
                                pageController.insertSegment(withTitle: "All Routes", at: 2, animated: false)
                                pageController.selectedSegmentIndex = 2
                                pageController.translatesAutoresizingMaskIntoConstraints = false
                                pageController.isUserInteractionEnabled = true
                                pageController.addTarget(self, action: #selector(handleControlPageChanged), for: .valueChanged)
                                // constrain the page controller
                                pageController.widthAnchor.constraint(equalToConstant: pageControllerWidth).isActive = true
                                pageController.heightAnchor.constraint(equalToConstant: pageControllerHeight).isActive = true
                                // configure the scroll view
                                scrollViewHeight = height - pageControllerHeight - searchBarHeight
                                scrollViewWidth = searchBarWidth - 16
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
                                        tableViewWidth = pageControllerWidth
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
                                                        // scroll the scroll view
                                                        scrollView.scrollRectToVisible(CGRect(x: Double(pageController.selectedSegmentIndex)*scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight), animated: false)
                                                        // configure the super table view
                                                        superViewStack = UIStackView(arrangedSubviews: [searchBar, pageController, scrollView])
                                                        stackViewSpacing = 4.0 * (height/812)
                                                        if let superViewStack = superViewStack, let stackViewSpacing = stackViewSpacing{
                                                            superViewStack.axis = .vertical
                                                            superViewStack.spacing = stackViewSpacing
                                                            superViewStack.alignment = .center
                                                            superViewStack.distribution = .equalSpacing
                                                            superViewStack.isUserInteractionEnabled = true
                                                            superViewStack.translatesAutoresizingMaskIntoConstraints = false
                                                            // add the super view stack to the hierarchy
                                                            self.view.addSubview(superViewStack)
                                                            // constrain the super view stack
                                                            viewMargins = self.view.safeAreaLayoutGuide
                                                            if let viewMargins = viewMargins{
                                                                superViewStack.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor).isActive = true
                                                                superViewStack.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor).isActive = true
                                                                superViewStack.topAnchor.constraint(equalTo: viewMargins.topAnchor, constant: 10).isActive = true
                                                               
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
    //MARK: - Setup data gatherer
    func setUpDataGatherer(){
        dataGatherer.delegate = self
        dataGatherer.gatherData(endpoint: "Routes")
    }
}

//MARK: - Provide Table View with data
extension HomeScreenMenuViewController: UITableViewDataSource {
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
            return "Routes"
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
            if let onCampusRoutes = onCampusRoutes, let offCampusRoutes = offCampusRoutes, let delegate = pathDelegate {
                if indexPath.section == 0 {
                    cell.icon = onCampusRoutes[indexPath.row].number
                    cell.text = onCampusRoutes[indexPath.row].name
                    cell.cellColor = onCampusRoutes[indexPath.row].color
                    onCampusRoutes[indexPath.row].delegate = delegate
                    return cell
                }
                else if indexPath.section == 1 {
                    cell.icon = offCampusRoutes[indexPath.row].number
                    cell.text = offCampusRoutes[indexPath.row].name
                    cell.cellColor = offCampusRoutes[indexPath.row].color
                    offCampusRoutes[indexPath.row].delegate = delegate
                    return cell
                }
            }
        }
        else if tableView == favoritesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenModalTableViewCell") as! HomeScreenModalTableViewCell
            cell.icon = "⭐️"
            cell.text = "Favorite Location"
            cell.cellColor = UIColor(named: "favoriteLocationGold")
            return cell
        }
        else if tableView == recentsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenModalTableViewCell") as! HomeScreenModalTableViewCell
            cell.icon = "📍"
            cell.text = "Recent Location"
            cell.cellColor = UIColor(named: "recentLocationRed")
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
extension HomeScreenMenuViewController: UITableViewDelegate {
    // manage selection of rows
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == allRoutesTableView {
            if indexPath.section == 0 {
                if let onCampusRoutes = onCampusRoutes {
                    onCampusRoutes[indexPath.row].displayBusRoute()
                    onCampusRoutes[indexPath.row].displayBuses()                    
                }
            }
            else if indexPath.section == 1 {
                if let offCampusRoutes = offCampusRoutes {
                    offCampusRoutes[indexPath.row].displayBusRoute()
                    offCampusRoutes[indexPath.row].displayBuses()
                    
                }
            }
        }
        // this line of code is required so that the keyboard will go away
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: false)
        // use this to alert the system to collapse the menu when a bus route is selected
        collapseNotification = Notification(name: Notification.Name(rawValue: "collapseMenu"))
        if let collapseNotification = collapseNotification {
            NotificationCenter.default.post(collapseNotification)
        }
    }
}
//MARK: - Handle Page Control Page Changed
extension HomeScreenMenuViewController {
    @objc func handleControlPageChanged(sender: UISegmentedControl){
        // end editing
        self.view.endEditing(true)
        // scroll each table view to the top when the associated button is pressed
        if let allRoutesTableView = allRoutesTableView, let recentsTableView = recentsTableView, let favoritesTableView = favoritesTableView {
            if sender.selectedSegmentIndex == 0 {
                recentsTableView.setContentOffset(.zero, animated: false)
            }
            else if sender.selectedSegmentIndex == 1 {
                favoritesTableView.setContentOffset(.zero, animated: false)
            }
            else if sender.selectedSegmentIndex == 2 {
                allRoutesTableView.setContentOffset(.zero, animated: false)
            }
        }
        // change the scroll views position based on the segmented control's selection
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
extension HomeScreenMenuViewController: DataGathererDelegate {
    func didGatherBusRoutes(onCampusRoutes: [BusRoute], offCampusRoutes: [BusRoute]) {
        self.onCampusRoutes = onCampusRoutes
        self.offCampusRoutes = offCampusRoutes
        RouteGenerator.shared.allRoutes = onCampusRoutes + offCampusRoutes
        DispatchQueue.main.async {
            self.allRoutesTableView?.reloadData()
        }
    }
}
//MARK: - Handle search bar interactions
extension HomeScreenMenuViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter = MKLocalSearchCompleter()
        searchResults = DropDown()
        if let searchCompleter = searchCompleter, let map = map, let searchResults = searchResults {
            searchCompleter.delegate = self
            searchCompleter.queryFragment = searchText
            searchCompleter.region = map.region
            if searchText.isEmpty {
                searchResults.dataSource = []
                searchResults.hide()
            }
            configureSearchResultsMenu()
        }
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        editingNotification = Notification(name: Notification.Name("didBeginEditing"))
        if let editingNotification = editingNotification {
            NotificationCenter.default.post(editingNotification)
        }
        searchBar.showsCancelButton = true
        searchBar.text = nil
        if let map = map {
            map.isScrollEnabled = false
            map.isZoomEnabled = false
            map.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.614965, longitude: -96.340584), span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))

        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        if let searchResults = searchResults {
            searchResults.hide()
        }
        if let map = map {
            map.isZoomEnabled = true
            map.isScrollEnabled = true
            map.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.614965, longitude: -96.340584), span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let map = map {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = searchBar.text
            searchRequest.region = map.region
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                guard let response = response else {
                    fatalError("Invalid search")
                }
                var locations:[Location] = []
                for item in response.mapItems {
                    if let name = item.name, let address = item.placemark.title, address.lowercased().contains("bryan") || address.lowercased().contains("college station") {
                        let location = Location(name: name, location: item.placemark.coordinate, address: address)
                        locations.append(location)
                        
                    }
                }
                if let locationIdentifierDelegate = self.locationIdentifierDelegate {
                    locationIdentifierDelegate.showLocationOnMap(results: locations)
                }
                self.collapseNotification = Notification(name: Notification.Name(rawValue: "collapseMenu"))
                if let collapseNotification = self.collapseNotification {
                    NotificationCenter.default.post(collapseNotification)
                }
            }
        }
    }
    
}
//MARK: - Conform to the auto completion delegation
extension HomeScreenMenuViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        addresses  = []
        options = []
            for result in completer.results {
                options.append(result.title)
                addresses.append(result.subtitle)
            }
            if let searchResults = searchResults {
                searchResults.dataSource = options
                searchResults.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                    guard let cell = cell as? SearchResultsDropDownCell else {return}
                    let addressAttributes: [NSAttributedString.Key:Any] = [
                        .font: UIFont.systemFont(ofSize: 14)
                    ]
                    cell.addressLabel.attributedText = NSAttributedString(string: self.addresses[index],attributes: addressAttributes)
                }
                searchResults.show()
            }
        }
}

//MARK: - configure search results menu
extension HomeScreenMenuViewController {
    func configureSearchResultsMenu() {
        cellNib = UINib(nibName: "SearchResultsDropDownCell", bundle: nil)
        if let searchResults = searchResults, let searchBar = searchBar, let cellNib = cellNib {
            searchResults.anchorView = searchBar.searchTextField
            searchResults.width = searchBar.searchTextField.frame.width
            searchResults.cellNib = cellNib
            searchResults.cornerRadius = 7.5
            searchResults.bottomOffset = CGPoint(x: 0, y: (searchResults.anchorView?.plainView.bounds.height)!+1)
            searchResults.direction = .bottom
            searchResults.backgroundColor = UIColor(named: "menuColor")
            searchResults.textColor = UIColor(named: "textColor")!
            searchResults.textFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            searchResults.dimmedBackgroundColor = .clear
            let modifiedLightGray = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 0.5)
            searchResults.selectionBackgroundColor = modifiedLightGray
            searchResults.selectedTextColor = UIColor(named: "textColor")!
            searchResults.selectionAction = { itemIndex, name in
                if let searchBar = self.searchBar {
                    searchBar.text = self.addresses[itemIndex] == "Search Nearby" ? self.options[itemIndex]:self.options[itemIndex]+" "+self.addresses[itemIndex]
                }
            }
            searchResults.separatorColor = UIColor(named: "borderColor") ?? .clear
            
        }
    }
    
}

