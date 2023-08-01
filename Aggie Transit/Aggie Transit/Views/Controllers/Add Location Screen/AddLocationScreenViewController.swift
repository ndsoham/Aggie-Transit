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
    var searchBar: UISearchBar = UISearchBar()
    var searchCollectionView: UICollectionView?
    let singleColumnLayout: SingleColumnLayout = SingleColumnLayout()
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
       
    }
    //MARK: - layout subviews
    func layoutSubviews() {
        setupSelf()
        setupSearchBar()
        setupSearchCollectionView()
    }
}
