//
//  FocusViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/11.
//

import UIKit

protocol FocusViewControllerDelegate: AnyObject {
    func closeButtonDidClicked(_ sender: UIViewController)
}

class FocusViewController: UIViewController {
    private lazy var closeButton: UIButton = {
        let button = CloseButton()
        button.addTarget(self, action: #selector(closeButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    weak var delegate: FocusViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(30)
        }
    }
    
    @objc func closeButtonClicked(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

