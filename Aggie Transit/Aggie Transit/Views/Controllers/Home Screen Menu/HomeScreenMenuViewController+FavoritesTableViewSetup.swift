//
//  HomeScreenMenuViewController+FavoritesTableViewSetup.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/14/23.
//

import Foundation
import UIKit

extension HomeScreenMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.id, for: indexPath) as! FavoritesTableViewCell
        cell.name = "Kings Cross Underground Station"
        cell.address = "New York"
        cell.contentView.backgroundColor = .systemGray//UIColor(red: 242.0, green: 242.0, blue: 247.0, alpha: 1)
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.clipsToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorites"
    }
    
    
    
}
