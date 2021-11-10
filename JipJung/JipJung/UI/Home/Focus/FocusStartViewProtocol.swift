//
//  FocusStartViewProtocol.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/08.
//

import UIKit

protocol FocusStarViewDelegate: AnyObject {
    func startButtonDidClicked()
    func endButtonDidClicked()
}

protocol FocusStartViewable: UIView {
    var delegate: FocusStarViewDelegate? { get set }
    func clickStartButton(_ sender: UIButton)
    func startFocus()
    func endFocus()
}
