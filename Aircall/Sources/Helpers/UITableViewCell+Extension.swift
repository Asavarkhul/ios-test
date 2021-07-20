//
//  UITableViewCell+Extension.swift
//  Aircall
//
//  Created by Bertrand BLOC'H on 19/07/2021.
//

import UIKit

extension UITableViewCell {
    
    /// A default reuse identifier for queuing in UITableView
    /// - returns: A reuse identifier based on Class Name
    class var defaultReuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
