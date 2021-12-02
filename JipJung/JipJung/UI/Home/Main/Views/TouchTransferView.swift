//
//  TouchTransferView.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/18.
//

import UIKit

final class TouchTransferView: UIView {
    var transferView: UIView?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        transferView?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        transferView?.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        transferView?.touchesEnded(touches, with: event)
    }
}
