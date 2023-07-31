//
//  AddLocationScreenViewController.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/30/23.
//

import Foundation
import UIKit
import MapKit
class AddLocationScreenViewController: UIViewController {
    //MARK: - attributes
    var map: MKMapView?
    var searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    let searchRequest = MKLocalSearch.Request()
    var searchCompleterResults: [Location] = []
    var searchResults: [Location] = []
    var searchBar: UISearchBar = UISearchBar()
    var searchCollectionView: UICollectionView?
    let singleColumnLayout: SingleColumnLayout = SingleColumnLayout()
    var cancelButton: UIButton = UIButton()
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
       
    }
    //MARK: - layout subviews
    func layoutSubviews() {
        setupSelf()
        setupCancelButton()
        setupSearchBar()
        setupSearchCollectionView()
    }
    //MARK: - handle button press
    @objc func didPressCancel() {
        self.dismiss(animated: true)
    }
}
