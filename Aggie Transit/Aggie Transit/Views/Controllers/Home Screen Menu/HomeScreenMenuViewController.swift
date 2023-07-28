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
import CoreData
import FloatingPanel
class HomeScreenMenuViewController: UIViewController {
    
    private var recentLocations: [RecentLocation]?
    private var notifications: [BusNotification]?
    private var editingNotification: Notification?
    private var collapseNotification: Notification?
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchResults: DropDown?
    private var cellNib: UINib?
    private var addresses: [String] = []
    private var options: [String] = []
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var searchBar: UISearchBar = UISearchBar()
    var container: NSPersistentContainer! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var map: MKMapView?
    var pathDelegate: PathMakerDelegate?
    var locationIdentifierDelegate: SearchResultsDelegate?
    var routeDisplayerDelegate: RouteDisplayerDelegate?
    var recentsTableView: UITableView = UITableView()
    var allRoutesTableView: UITableView = UITableView()
    var notificationsTableView: UITableView = UITableView()
    var favoritesTableView: UITableView = UITableView()
    var singleColumnLayout: SingleColumnLayout = SingleColumnLayout()
    var favoritesCollectionView: UICollectionView?
    deinit {NotificationCenter.default.removeObserver(self)}
    //MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDataTasks()
        layoutSubviews()
    }
    //MARK: - Register notification in order to fetch relevant data
    func registerDataTasks() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchTableData), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    //MARK: - fetch relevant data
    @objc func fetchTableData() {
//        setUpDataGatherer()
        checkContainerStatus()
        fetchRecentLocations()
    }
    //MARK: - Fetch recent locations
    func fetchRecentLocations() {
        do {
            let request = RecentLocation.fetchRequest() as NSFetchRequest<RecentLocation>
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            var retrievedLocations = try container.viewContext.fetch(request)
            // delete some if more than ten locations are present
            if retrievedLocations.count > 10 {
                retrievedLocations = Array(retrievedLocations[...9])
                let locationsToBeDeleted = retrievedLocations[10...]
                for location in locationsToBeDeleted {
                    container.viewContext.delete(location)
                }
            }
            recentLocations = retrievedLocations
            try container.viewContext.save()
            DispatchQueue.main.async {
                self.recentsTableView.reloadData()
            }
        } catch {
            let alert = UIAlertController(title: "Alert", message: "\(error.localizedDescription)", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
        
    }
    //MARK: - check container status
    func checkContainerStatus() {
        guard container != nil else {
            let alert = UIAlertController(title: "Alert", message: "Database not initialized correctly.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            return
        }
    }
    //MARK: - layout subviews
    func layoutSubviews() {
        setupSelf()
        setupSearchBar()
//        setupFavoritesTableView()
        setupFavoritesCollectionView()
    }
//    //MARK: - layout the subviews
//    func layoutSubviews() {
//        // register the cell
//        recentsTableView.register(RecentLocationsTableViewCell.self, forCellReuseIdentifier: "recentLocationsTableViewCell")
//        allRoutesTableView.register(BusRouteTableViewCell.self, forCellReuseIdentifier: "busRoutesTableViewCell")
//        notificationsTableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "notificationsTableViewCell")
//        // configure the recents table view
//        recentsTableView.dataSource = self
//        recentsTableView.delegate = self
//        recentsTableView.translatesAutoresizingMaskIntoConstraints = false
//        recentsTableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//        recentsTableView.separatorStyle = .none
//        recentsTableView.allowsSelection = true
//        recentsTableView.allowsMultipleSelection = false
//        recentsTableView.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight-54)
//        // configure the all routes table view
//        allRoutesTableView.allowsMultipleSelection = false
//        allRoutesTableView.allowsSelection = true
//        allRoutesTableView.dataSource = self
//        allRoutesTableView.delegate = self
//        allRoutesTableView.translatesAutoresizingMaskIntoConstraints = false
//        allRoutesTableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//        allRoutesTableView.separatorStyle = .none
//        allRoutesTableView.frame = CGRect(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight-54)
//        allRoutesTableView.scrollsToTop = true
//        // configure the notifications table view
//        notificationsTableView.dataSource = self
//        notificationsTableView.delegate = self
//        notificationsTableView.translatesAutoresizingMaskIntoConstraints = false
//        notificationsTableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//        notificationsTableView.separatorStyle = .none
//        notificationsTableView.allowsSelection = false
//        notificationsTableView.allowsMultipleSelection = false
//        notificationsTableView.frame = CGRect(x: scrollViewWidth*2, y: 0, width: scrollViewWidth, height: scrollViewHeight-54)
//        scrollView.scrollRectToVisible(CGRect(x: scrollViewWidth*Double(pageController.selectedSegmentIndex), y: 0, width: scrollViewWidth, height: scrollViewHeight), animated: false)
//        scrollView.addSubview(recentsTableView)
//        scrollView.addSubview(allRoutesTableView)
//        scrollView.addSubview(notificationsTableView)
//        // set up the activity indicator
//        self.view.addSubview(activityIndicator)
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        activityIndicator.style = .large
//        activityIndicator.centerXAnchor.constraint(equalTo: safeMargins.centerXAnchor).isActive = true
//        activityIndicator.centerYAnchor.constraint(equalTo: safeMargins.centerYAnchor).isActive = true
//
//}
//MARK: - Setup data gatherer
//func setUpDataGatherer(){
//    dataGatherer.delegate = self
//    dataGatherer.gatherData(endpoint: "routes")
//    dataGatherer.gatherData(endpoint: "announcements")
//    dataGatherer.alertDelegate = self
//}
}
////MARK: - Provide Table View with data
//extension HomeScreenMenuViewController: UITableViewDataSource {
//    // provide the number of sections
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if tableView == allRoutesTableView {
//            return 2
//        }
//        else if tableView == recentsTableView {
//            return 1
//        } else if tableView == notificationsTableView {
//            return 1
//        }
//        return -1
//    }
//    // provide the title for each section
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if tableView == allRoutesTableView {
//            if section == 0 {
//                return "On-Campus"
//            }
//            else {
//                return "Off-Campus"
//            }
//        }
//        if tableView == recentsTableView {
//            return "Recent Locations"
//        }
//        else if tableView == notificationsTableView {
//            return "Notifications"
//        }
//        return ""
//    }
//    // provide number of rows in section
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == allRoutesTableView {
//            if section == 0 {
//                if let onCampusRoutes = self.onCampusRoutes {
//                    return onCampusRoutes.count
//                }
//            }
//            else if section == 1 {
//                if let offCampusRoutes = self.offCampusRoutes {
//                    return offCampusRoutes.count
//                }
//            }
//        }
//        else if tableView == recentsTableView {
//            if let recentLocations {
//                return recentLocations.count
//            }
//
//        }
//        else if tableView == notificationsTableView {
//            if let notifications {
//                return notifications.count
//            }
//        }
//        return -1
//    }
//    // provide a cell for each row
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == allRoutesTableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "busRoutesTableViewCell") as! BusRouteTableViewCell
//            if let onCampusRoutes = onCampusRoutes, let offCampusRoutes = offCampusRoutes, let delegate = pathDelegate {
//                let attributes: [NSAttributedString.Key:Any] = [
//                    .font:UIFont.boldSystemFont(ofSize: 17),
//                    .foregroundColor:UIColor(named: "textColor") ?? .black
//                ]
//                if indexPath.section == 0 && cell.icon == nil, cell.busName == nil, cell.cellColor == nil {
//                    let boldedIcon = NSAttributedString(string: onCampusRoutes[indexPath.row].number, attributes: attributes)
//                    cell.icon = boldedIcon
//                    cell.busName = NSAttributedString(string: onCampusRoutes[indexPath.row].name, attributes: attributes)
//                    cell.cellColor = onCampusRoutes[indexPath.row].color
//                    cell.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//                    onCampusRoutes[indexPath.row].delegate = delegate
//                    return cell
//                }
//                else if indexPath.section == 1 {
//                    let boldedIcon = NSAttributedString(string: offCampusRoutes[indexPath.row].number,attributes: attributes)
//                    cell.icon = boldedIcon
//                    cell.busName = NSAttributedString(string: offCampusRoutes[indexPath.row].name, attributes: attributes)
//                    cell.cellColor = offCampusRoutes[indexPath.row].color
//                    cell.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//                    offCampusRoutes[indexPath.row].delegate = delegate
//                    return cell
//                }
//            }
//        }
//        else if tableView == recentsTableView {
//            if let recentLocations {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "recentLocationsTableViewCell") as! RecentLocationsTableViewCell
//                if cell.name == nil, cell.address == nil {
//                    cell.name = recentLocations[indexPath.row].name
//                    cell.address = recentLocations[indexPath.row].address
//                    cell.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
//                    return cell
//                }
//            }
//        }
//        else if tableView == notificationsTableView {
//            if let notifications {
//                let cell = tableView.dequeueReusableCell(withIdentifier:"notificationsTableViewCell") as! NotificationsTableViewCell
//                cell.alertTitle = notifications[indexPath.row].title
//                cell.alertContent = notifications[indexPath.row].content
//                return cell
//            }
//        }
//        return UITableViewCell()
//    }
//    // provide a height for each row
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == notificationsTableView {
//            return 165
//        }
//        return 110
//    }
//}
////MARK: - Conform to Table View's Delegate
//extension HomeScreenMenuViewController: UITableViewDelegate {
//    // manage selection of rows
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == allRoutesTableView {
//            if indexPath.section == 0 {
//                if let onCampusRoutes = onCampusRoutes {
//                    onCampusRoutes[indexPath.row].displayBusRoute()
//                }
//            }
//            else if indexPath.section == 1 {
//                if let offCampusRoutes = offCampusRoutes {
//                    offCampusRoutes[indexPath.row].displayBusRoute()
//                }
//            }
//        }
//        if tableView == recentsTableView {
//            if let recentLocations, let currentLocation = LocationManager.shared.currentLocation, let desName = recentLocations[indexPath.row].name, let address = recentLocations[indexPath.row].address {
//                let origin = Location(name: "Current Location", location: currentLocation.coordinate, address: "")
//                let destination = Location(name: desName, location: CLLocationCoordinate2D(latitude: recentLocations[indexPath.row].latitude, longitude: recentLocations[indexPath.row].longitude), address: address)
//                self.generateRoute(origin: origin, destination: destination)
//            }
//        }
//        // this line of code is required so that the keyboard will go away
//        self.view.endEditing(true)
//        tableView.deselectRow(at: indexPath, animated: false)
//        // use this to alert the system to collapse the menu when a bus route is selected
//        collapseNotification = Notification(name: Notification.Name(rawValue: "collapseMenu"))
//        if let collapseNotification = collapseNotification {
//            NotificationCenter.default.post(collapseNotification)
//        }
//    }
//}
//MARK: - Handle Data Gathering/ etc.
extension HomeScreenMenuViewController: DataGathererDelegate {
    func didGatherBusRoutes(onCampusRoutes: [BusRoute], offCampusRoutes: [BusRoute]) {
//        self.onCampusRoutes = onCampusRoutes
//        self.offCampusRoutes = offCampusRoutes
        RouteGenerator.shared.allRoutes = onCampusRoutes + offCampusRoutes
        DispatchQueue.main.async {
            self.allRoutesTableView.reloadData()
        }
    }
    func didGatherNotifications(notifications: [BusNotification]) {
        self.notifications = notifications
        DispatchQueue.main.async {
            self.notificationsTableView.reloadData()
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
        activityIndicator.stopAnimating()
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let map = map {
            activityIndicator.startAnimating()
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = searchBar.text
            searchRequest.region = map.region
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                if let error = error {
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.activityIndicator.stopAnimating()
                    self.displayAlert(alert: alert)
                }
                if let response {
                    var locations:[Location] = []
                    for item in response.mapItems {
                        if let name = item.name, let address = item.placemark.title, address.lowercased().contains("bryan") || address.lowercased().contains("college station") {
                            let location = Location(name: name, location: item.placemark.coordinate, address: address)
                            if let currentLocation = LocationManager.shared.currentLocation {
                                // do this to round to two decimal places
                                location.distance = round((location.location.distance(to: currentLocation.coordinate) * 0.0006213712)*10)/10.0
                            }
                            locations.append(location)
                        }
                    }
                    locations = locations.sorted {
                        if let firstDistance = $0.distance, let secondDistance = $1.distance {
                            return firstDistance < secondDistance
                        } else {
                            return false
                        }
                    }
                    if let locationIdentifierDelegate = self.locationIdentifierDelegate {
                        self.activityIndicator.stopAnimating()
                        locationIdentifierDelegate.displaySearchResults(results: locations)
                    }
                    self.collapseNotification = Notification(name: Notification.Name(rawValue: "collapseMenu"))
                    if let collapseNotification = self.collapseNotification {
                        NotificationCenter.default.post(collapseNotification)
                    }
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
        if let searchResults = searchResults, let cellNib = cellNib {
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
                self.searchBar.text = self.addresses[itemIndex] == "Search Nearby" ? self.options[itemIndex]:self.options[itemIndex]+" "+self.addresses[itemIndex]
            }
            searchResults.separatorColor = UIColor(named: "borderColor 1") ?? .clear
            
        }
    }
    
}
//MARK: - Refresh recent locations when update
extension HomeScreenMenuViewController: RefreshDelegate {
    func refreshRecentLocations() {
        self.fetchRecentLocations()
    }
}
