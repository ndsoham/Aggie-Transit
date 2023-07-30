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
    var recentLocations: [RecentLocation]?
    private var notifications: [BusNotification]?
    private var collapseNotification: Notification?
    var searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    let searchRequest = MKLocalSearch.Request()
    var searchCompleterResults: [Location] = []
    var searchResults: [Location] = []
    var searchBar: UISearchBar = UISearchBar()
    var container: NSPersistentContainer! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var map: MKMapView?
    var pathDelegate: PathMakerDelegate?
    var routeDisplayerDelegate: RouteDisplayerDelegate?
    var recentsTableView: UITableView = UITableView()
    var allRoutesTableView: UITableView = UITableView()
    var notificationsTableView: UITableView = UITableView()
    var favoritesTableView: UITableView = UITableView()
    var singleColumnLayout: SingleColumnLayout = SingleColumnLayout()
    var defaultCollectionView: UICollectionView?
    var searchCollectionView: UICollectionView?
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
        setupDefaultCollectionView()
    }
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
//MARK: - Refresh recent locations when update
extension HomeScreenMenuViewController: RefreshDelegate {
    func refreshRecentLocations() {
        self.fetchRecentLocations()
    }
}
