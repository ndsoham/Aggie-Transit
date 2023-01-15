//
//  HomeScreenViewController+Alerts.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/13/23.
//

import Foundation
import UIKit
protocol AlertDelegate {
    func displayAlert(alert: UIAlertController)
}

extension HomeScreenMenuViewController: AlertDelegate {
    func displayAlert(alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
