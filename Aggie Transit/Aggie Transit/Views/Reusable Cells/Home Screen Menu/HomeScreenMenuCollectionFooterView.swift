//
//  HomeScreenMenuCollectionFooterView.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/26/23.
//

import Foundation
import UIKit

protocol AddDelegate {
    func addPressed()
}

class HomeScreenMenuCollectionFooterView: UICollectionReusableView {
    //MARK: - attributes
    var addButton: UIButton = UIButton(type: .system)
    var delegate: AddDelegate?
    var footerName: String?
    static let id: String = "FavoritesFooterView"
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    //MARK: - setup ui
    override func layoutSubviews() {
        super.layoutSubviews()
        setupAddButton()
    }
    //MARK: - handle button events
    @objc func didPressAdd() {
        self.delegate?.addPressed()
    }
}

