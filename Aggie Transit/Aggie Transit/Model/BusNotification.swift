//
//  Notification.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/16/23.
//

import Foundation
import UIKit
//MARK: - This class is used to display a single notification recieved from the api
@objc class BusNotification: NSObject {
    var content: String
    var title: String
    init(content: String, title: String) {
        self.content = content
        self.title = title
    }
}
