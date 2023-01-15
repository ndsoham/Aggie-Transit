//
//  Unnamed.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/16/22.
//

import UIKit

class RecentLocationsTableViewCell: UITableViewCell {
    private var cornerRadius: Double = 36.75
    private let borderWidth = 1.5
    private var width: Double?
    private var height: Double?
    private var view: UIView?
    private var viewHeight: Double?
    private var viewWidth: Double?
    private var margins: UILayoutGuide?
    private var viewMargins: UILayoutGuide?
    private var icon: UIImageView?
    private var customTextLabel: UILabel?
    private var stackView: UIStackView?
    private var textStack: UIStackView?
    private var addressLabel: UILabel?
    var address: String?
    var text: String?
    private var baseView: UIView?
    private var cellBaseView: UIView?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder){
        fatalError()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.addressLabel?.text = nil
        self.customTextLabel?.text = nil
        self.icon?.image = nil
        self.clearsContextBeforeDrawing = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectedBackgroundView = nil
        // access the views width and height
        width = self.contentView.frame.width
        height = self.contentView.frame.height
        self.contentView.backgroundColor = .red//UIColor(named: "launchScreenBackgroundColor")
        if let width = width, let height = height {
            // add a subview to the view and shape it accordingly
            viewHeight = 86.25 * (height/110)
            viewWidth = (355-16) * (width/375)
            if let viewHeight, let viewWidth {
                    view = UIView()
                    baseView = UIView()
                    cellBaseView = UIView()
                    if let view, let baseView, let cellBaseView {
                        // configure the view
                        view.layer.cornerRadius = cornerRadius
                        view.layer.borderWidth = borderWidth
                        view.layer.borderColor = UIColor(named: "borderColor")?.cgColor
                        view.backgroundColor = UIColor(named: "menuColor")
                        view.translatesAutoresizingMaskIntoConstraints = false
                        // configure base view
                        baseView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                        baseView.translatesAutoresizingMaskIntoConstraints = false
                        // configure cell base view
                        cellBaseView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                        cellBaseView.translatesAutoresizingMaskIntoConstraints = false
                        // add to the view hierarchy
                        self.contentView.addSubview(cellBaseView)
                        self.contentView.addSubview(baseView)
                        self.contentView.addSubview(view)
                        // add constraints
                        margins = self.safeAreaLayoutGuide
                        if let margins = margins {
                            view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
                            view.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
                            view.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
                            view.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
                            baseView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
                            baseView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
                            baseView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
                            baseView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
                            cellBaseView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
                            cellBaseView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
                            cellBaseView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
                            cellBaseView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
                        }
                        // create stack view
                        stackView = UIStackView()
                        if let stackView = stackView{
                            // configure stackView
                            stackView.alignment = .center
                            stackView.distribution = .fill
                            stackView.axis = .horizontal
                            stackView.spacing = 8
                            stackView.translatesAutoresizingMaskIntoConstraints = false
                            // add stackview to view hierarchy
                            view.addSubview(stackView)
                            // add constraints
                            viewMargins = view.safeAreaLayoutGuide
                            if let viewMargins = viewMargins {
                                stackView.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor,constant: 30).isActive = true
                                stackView.centerYAnchor.constraint(equalTo: viewMargins.centerYAnchor).isActive = true
                                stackView.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor, constant: -30).isActive = true
                            }
                            // create icon label and text label
                            icon = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
                            customTextLabel = UILabel()
                            textStack = UIStackView()
                            addressLabel = UILabel()
                            let nameAttributes: [NSAttributedString.Key:Any] = [
                                .font:UIFont.boldSystemFont(ofSize: 18),
                                .foregroundColor:UIColor(named: "textColor") ?? .black
                            ]
                            let addressAttributes: [NSAttributedString.Key:Any] = [
                                .font:UIFont.systemFont(ofSize: 14),
                                .foregroundColor:UIColor(named: "textColor")?.withAlphaComponent(0.75) ?? .black
                            ]
                            if let icon, let customTextLabel, let text, let textStack, let address, let addressLabel {
                                // configure text stack
                                textStack.alignment = .leading
                                textStack.distribution = .fill
                                textStack.axis = .vertical
                                textStack.translatesAutoresizingMaskIntoConstraints = false
                                customTextLabel.attributedText = NSAttributedString(string: text, attributes: nameAttributes)
                                addressLabel.attributedText = NSAttributedString(string: address, attributes: addressAttributes)
                                customTextLabel.clipsToBounds = true
                                addressLabel.clipsToBounds = true
                                icon.clipsToBounds = true
                                customTextLabel.textColor = UIColor(named: "modalTableCellTextColor")
                                icon.tintColor = UIColor(named: "recentLocationRed")
                                icon.translatesAutoresizingMaskIntoConstraints = false
                                // add constraints
                                icon.widthAnchor.constraint(equalToConstant: 21).isActive = true
                                icon.widthAnchor.constraint(equalToConstant: 21).isActive = true
                                customTextLabel.translatesAutoresizingMaskIntoConstraints = false
                                addressLabel.translatesAutoresizingMaskIntoConstraints = false
                                // add to view hierarchy
                                stackView.addArrangedSubview(icon)
                                textStack.addArrangedSubview(customTextLabel)
                                textStack.addArrangedSubview(addressLabel)
                                stackView.addArrangedSubview(textStack)
                                
                            }
                        }
                        
                    }
                
            }
            
        }
        
    }
    
}
