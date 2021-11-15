//
//  FocusViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/11.
//

import UIKit
import RxSwift
import RxCocoa

class FocusViewController: UIViewController {
    private let closeButton = CloseButton()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCloseButton()
        bindCloseButton()
    }
    
    private func configureCloseButton() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(30)
        }
    }
    
    private func bindCloseButton() {
        closeButton.rx.tap.bind { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        .disposed(by: disposeBag)
    }
}

