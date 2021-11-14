//
//  UITableViewCell+Extension.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/14.
//

import UIKit

extension UITableView {
    enum CellIdentifier {
        case search
        
        var value: String {
            switch self {
            case .search:
                return String(describing: SearchTableViewCell.self)
            }
        }
    }
    
    func cell(identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}
