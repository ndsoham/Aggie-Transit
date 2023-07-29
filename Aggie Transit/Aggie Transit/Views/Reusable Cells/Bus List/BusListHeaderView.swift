//
//  BusListHeaderView.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 7/28/23.
//

import Foundation
import UIKit

protocol DismissalDelegate {
    func viewDismissed()
}

protocol FilterDelegate {
    func sectionChanged()
}

class BusListHeaderView: UICollectionReusableView {
    //MARK: - attributes
    var section: String?
    var sectionButton: UIButton = UIButton()
    var closeButton: UIButton = UIButton(type: .system)
    var dismissalDelegate: DismissalDelegate?
    var filterDelegate: FilterDelegate?
    static let id: String = "BusListHeaderView"
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
    //MARK: - setup UI
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSectionButton()
        setupCloseButton()
    }
    //MARK: - section changed
    @objc func didChangeSection() {
        self.filterDelegate?.sectionChanged()
    }
    //MARK: - view closed
    @objc func didCloseView() {
        self.dismissalDelegate?.viewDismissed()
    }
    
}
