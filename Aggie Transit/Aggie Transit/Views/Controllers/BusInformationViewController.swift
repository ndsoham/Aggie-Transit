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
    private var timeTableView: UITableView?
    private var headingLabel: UILabel?
    private var closeButton: UIButton?
    var busNumber: String?
    var busColor: UIColor?
    var busName: String?
    var favorited: Bool?
    var timeTable: [[String:Date?]]?
    var keyOrder: [String]? {
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
    private var safeMargins: UILayoutGuide?
    private var sidePadding: Double?
    private var topInset: Double?
    private var busNumberView: UIView?
    var closeDelegate: BusInformationPanelClosedDelegate?
    private var busNumberLabel: UILabel?
    private var busNumberViewHeight: Double = 42
    private var favoriteButton: UIButton?
    var container: NSPersistentContainer! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var refreshDelegate: RefreshDelegate?
    var center: UNUserNotificationCenter = UNUserNotificationCenter.current()
    private var timesTableView: UITableView?
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
        headingLabel = UILabel()
        busNumberView = UIView()
        busNumberLabel = UILabel()
        closeButton = UIButton(type: .close)
        favoriteButton = UIButton()
        safeMargins = self.view.safeAreaLayoutGuide
        topInset = 10
        sidePadding =  22.5 *  Double(self.view.frame.width/375)
        timesTableView = UITableView()
        if let headingLabel, let busNumberView, let closeButton, let safeMargins, let topInset, let sidePadding, let busName, let busNumber, let busColor, let busNumberLabel, let favoriteButton, let timesTableView {
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
                .foregroundColor:UIColor(named: "textColor") ?? .black
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
            // add a favorites button
            favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
            self.view.addSubview(favoriteButton)
            favoriteButton.translatesAutoresizingMaskIntoConstraints = false
            favoriteButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -sidePadding/2).isActive = true
            favoriteButton.centerYAnchor.constraint(equalTo: headingLabel.centerYAnchor).isActive = true
            favoriteButton.addTarget(self, action: #selector(addBusRouteToFavorites), for: .touchUpInside)
            // set up the table view
            timesTableView.register(TimeTableTableViewCell.self, forCellReuseIdentifier: "timeTableTableViewCell")
            timesTableView.allowsSelection = false
            timesTableView.translatesAutoresizingMaskIntoConstraints = false
            timesTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            timesTableView.separatorColor = UIColor(named: "borderColor")
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
    @objc func addBusRouteToFavorites(sender: UIButton) {
       
        if sender.isSelected {
            sender.isSelected = false
            
        }
        else if !sender.isSelected{
            promptUserForNotificationsAccess()
            sender.isSelected = true
            
        }
    }
    func promptUserForNotificationsAccess() {
        center.requestAuthorization(options: [.alert, .badge]) { granted, error in
            if let error {
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                DispatchQueue.main.async{
                    self.present(alert, animated: true)
                }
            }
            if !granted {
                let alert = UIAlertController(title: "Alert", message: "Proximity alerts will not work without notifications. Please change your settings.", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return busNumberViewHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        let safeMargins = view.safeAreaLayoutGuide
        let labelStack = UIStackView()
        labelStack.axis = .horizontal
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.distribution = .fill
        view.addSubview(labelStack)
        labelStack.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor).isActive = true
        labelStack.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor).isActive = true
        labelStack.bottomAnchor.constraint(equalTo: safeMargins.bottomAnchor).isActive = true
        labelStack.topAnchor.constraint(equalTo: safeMargins.topAnchor).isActive = true
        let labelAttributes: [NSAttributedString.Key:Any] = [
            .font:UIFont.boldSystemFont(ofSize: 11),
            .foregroundColor:UIColor(named: "textColor") ?? .black
        ]
        if let keyOrder, let topInset {
            for key in keyOrder {
                if key == " " {
                    let label = UILabel()
                    label.text = "No service scheduled."
                    label.translatesAutoresizingMaskIntoConstraints = false
                    view.addSubview(label)
                    label.topAnchor.constraint(equalTo: safeMargins.topAnchor, constant: topInset).isActive = true
                    label.centerXAnchor.constraint(equalTo: safeMargins.centerXAnchor).isActive = true
                    return view
                }
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.widthAnchor.constraint(equalToConstant: tableView.frame.width/CGFloat(keyOrder.count)).isActive = true
                let index = key.index(key.startIndex, offsetBy: 36)
                label.attributedText = NSAttributedString(string: (String(key[index...])), attributes: labelAttributes)
                label.textAlignment = .center
                label.numberOfLines = 3
                labelStack.addArrangedSubview(label)
            }
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.rowHeight * 2
    }
}
