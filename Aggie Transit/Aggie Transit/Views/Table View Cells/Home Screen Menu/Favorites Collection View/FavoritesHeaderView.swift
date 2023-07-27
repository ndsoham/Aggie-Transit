//
//  FavoritesHeaderView.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/18/23.
//

import Foundation
import UIKit

protocol ExpansionDelegate {
    func sectionExpanded()
}
class FavoritesHeaderView: UICollectionReusableView {
    //MARK: - attributes
    var headerLabel: UILabel = UILabel()
    var headerName: String?
    var expandButton: UIButton = UIButton(type: .system)
    var delegate: ExpansionDelegate?
    static let id: String = "FavoritesHeaderView"
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
        self.headerName = nil
    }
    //MARK: - setup UI
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLabel()
        setupExpandButton()
    }
    //MARK: - manage button actions
    @objc func didPressExpand() {
        self.delegate?.sectionExpanded()
    }
}
