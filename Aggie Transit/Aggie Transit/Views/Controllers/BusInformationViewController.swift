//
//  BusInformationViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/15/23.
//

import Foundation
import UIKit
import CoreData
class BusInformationViewController: UIViewController {
    private var timeTableView: UITableView = UITableView()
    private var headingLabel: UILabel = UILabel()
    private var closeButton: UIButton = UIButton(type: .close)
    private var safeMargins: UILayoutGuide?
    private var sidePadding: Double?
    private let topInset: Double = 10
    private var busNumberView: UIView = UIView()
    private var timesTableView: UITableView = UITableView()
    private var busNumberLabel: UILabel = UILabel()
    private var busNumberViewHeight: Double = 42
    var container: NSPersistentContainer! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var refreshDelegate: RefreshDelegate?
    var center: UNUserNotificationCenter = UNUserNotificationCenter.current()
    var closeDelegate: BusInformationPanelClosedDelegate?
    var busNumber: String?
    var busColor: UIColor?
    var busName: String?
    var favorited: Bool?
    var timeTable: [[String:Date?]]?
    var keyOrder: [String]? {
        // use this to return the correct key order when displaying time data
        get {
            if let timeTable{
                let keys = Array(timeTable[timeTable.count/2].keys)
                let sortedKeys = keys.sorted {
                    if let firstDate = timeTable[timeTable.count/2][$0], let secondDate =  timeTable[timeTable.count/2][$1], let firstDate, let secondDate {
                        return firstDate < secondDate
                    } else {
                        return false
                    }
                }
                return sortedKeys
            }
            return nil
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
        checkContainerStatus()
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
        self.view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        safeMargins = self.view.safeAreaLayoutGuide
        sidePadding =  22.5 *  Double(self.view.frame.width/375)
        timesTableView = UITableView()
        if  let safeMargins, let sidePadding, let busName, let busNumber, let busColor {
            busNumberLabel.translatesAutoresizingMaskIntoConstraints = false
            headingLabel.translatesAutoresizingMaskIntoConstraints = false
            busNumberView.translatesAutoresizingMaskIntoConstraints = false
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            // set up bus color view
            busNumberView.backgroundColor = busColor
            busNumberView.translatesAutoresizingMaskIntoConstraints = false
            busNumberView.layer.cornerRadius = busNumberViewHeight / 2
            busNumberView.layer.borderColor = UIColor(named: "borderColor")?.cgColor
            busNumberView.layer.borderWidth = 1.5
            // add to view hierarchy and constrain
            self.view.addSubview(busNumberView)
            busNumberView.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor, constant: sidePadding).isActive = true
            busNumberView.topAnchor.constraint(equalTo: safeMargins.topAnchor, constant: topInset).isActive = true
            busNumberView.heightAnchor.constraint(equalToConstant: busNumberViewHeight).isActive = true
            busNumberView.widthAnchor.constraint(equalToConstant: busNumberViewHeight).isActive = true
            // set up the bus number label
            let attributes: [NSAttributedString.Key:Any] = [
                .font:UIFont.boldSystemFont(ofSize: 12),
                .foregroundColor:UIColor(named: "busNumberTextColor") ?? .black
            ]
            busNumberLabel.attributedText = NSAttributedString(string: busNumber, attributes: attributes)
            // add to view hierarhcy and constrain
            busNumberView.addSubview(busNumberLabel)
            busNumberLabel.centerXAnchor.constraint(equalTo: busNumberView.safeAreaLayoutGuide.centerXAnchor).isActive = true
            busNumberLabel.centerYAnchor.constraint(equalTo: busNumberView.safeAreaLayoutGuide.centerYAnchor).isActive = true
            // set up heading label
            let headingAttributes: [NSAttributedString.Key:Any] = [
                .font:UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor:UIColor(named: "textColor") ?? .black
            ]
            headingLabel.attributedText = NSAttributedString(string: busName, attributes: headingAttributes)
            // add to view hierarchy and constrain
            self.view.addSubview(headingLabel)
            headingLabel.centerYAnchor.constraint(equalTo: busNumberView.centerYAnchor).isActive = true
            headingLabel.leadingAnchor.constraint(equalTo: busNumberView.trailingAnchor, constant: sidePadding/2).isActive = true
            // configure close button
            self.view.addSubview(closeButton)
            closeButton.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor, constant: -sidePadding).isActive = true
            closeButton.centerYAnchor.constraint(equalTo: headingLabel.centerYAnchor).isActive = true
            // add target
            closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
            // set up the table view; register header footer/table view cell
            timesTableView.register(TimeTableTableViewCell.self, forCellReuseIdentifier: "timeTableTableViewCell")
            timesTableView.register(TimeTableHeaderViewCell.self, forHeaderFooterViewReuseIdentifier: "timeTableHeaderViewCell")
            timesTableView.allowsSelection = false
            timesTableView.translatesAutoresizingMaskIntoConstraints = false
            timesTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            timesTableView.separatorColor = timesTableView.backgroundColor //UIColor(named: "borderColor")
            timesTableView.dataSource = self
            timesTableView.delegate = self
            timesTableView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
            timesTableView.rowHeight = busNumberViewHeight
            // add to view hierarchy and constrain
            self.view.addSubview(timesTableView)
            timesTableView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: topInset).isActive = true
            timesTableView.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor, constant: sidePadding).isActive = true
            timesTableView.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor, constant: -sidePadding).isActive = true
            timesTableView.bottomAnchor.constraint(equalTo: safeMargins.bottomAnchor).isActive = true
        }
    }
}
//MARK: - deal with button presses
extension BusInformationViewController {
    @objc func closeButtonPressed(sender: UIButton) {
        if let delegate = closeDelegate {
            delegate.closeBusInformationPanel()
        }
    }
}

//MARK: - deal with tableview delegate
extension BusInformationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let timeTable, let first = timeTable.first, first[" "] != nil as Date? {
            return timeTable.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableTableViewCell") as! TimeTableTableViewCell
        if cell.times == nil {
            if let timeTable, let keyOrder = keyOrder {
                let row = timeTable[indexPath.row]
                var dates: [Date?] = []
                for key in keyOrder {
                    if let date = row[key] {
                        dates.append(date)
                    }
                }
                cell.times = dates
            }
            if indexPath.row % 2 == 0 {
                cell.cellColor = UIColor(named: "menuColor")
            } else {
                cell.cellColor = UIColor(named: "launchScreenBackgroundColor")
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return busNumberViewHeight
    }
    //MARK: - return a view containing each time point's name
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "timeTableHeaderViewCell") as! TimeTableHeaderViewCell
        if view.timeStops == nil {
            view.timeStops = keyOrder
            return view
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.rowHeight * 1.5
    }
}
