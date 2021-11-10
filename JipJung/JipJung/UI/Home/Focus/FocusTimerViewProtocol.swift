//
//  FocusTimerViewProtocol.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/08.
//

import UIKit

protocol FocusTimerViewDelegate: AnyObject {
    func timeDidSet(with value: Int)
}

protocol FocusTimerViewable: UIView {
    var delegate: FocusTimerViewDelegate? { get set }
    func startFocus(with time: String)
    func endFocus()
    func changeTime(with time: String)
}
