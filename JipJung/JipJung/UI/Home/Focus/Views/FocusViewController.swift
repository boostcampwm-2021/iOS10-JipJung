//
//  FocusViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/11.
//

import UIKit

import RxCocoa
import RxSwift

class FocusViewController: UIViewController {
    let closeButton = CloseButton()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCloseButton()
        bindCloseButton()
    }
    
    private func configureCloseButton() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.top.equalTo(view.snp.topMargin).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(30)
        }
    }
    
    private func bindCloseButton() {
        closeButton.rx.tap.bind { [weak self] _ in
            self?.dismiss(animated: true) {
                NotificationCenter.default.post(
                    name: .showCarouselView,
                    object: nil,
                    userInfo: nil
                )
            }
        }
        .disposed(by: disposeBag)
    }
}
