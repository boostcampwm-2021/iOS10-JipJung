//
//  UITableViewCell+Extension.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/14.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        return register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T? {
        return self.dequeueReusableCell(withIdentifier: T.identifier) as? T
    }
}
