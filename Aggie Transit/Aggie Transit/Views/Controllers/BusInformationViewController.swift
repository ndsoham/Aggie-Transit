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
        if let headingLabel, let busNumberView, let closeButton, let safeMargins, let topInset, let sidePadding, let busName, let busNumber, let busColor, let busNumberLabel, let favoriteButton {
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
