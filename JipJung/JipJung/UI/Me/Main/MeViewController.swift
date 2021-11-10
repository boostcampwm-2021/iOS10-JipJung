//
//  MeViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//

import UIKit

import SnapKit

class MeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        // Do any additional setup after loading the view.
        
        let button = UIButton(type: .system)
        button.setTitle("음원상세화면", for: .normal)
        button.addTarget(self, action: #selector(buttonTouched(_:)), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func buttonTouched(_ sender: UIButton) {
        print(#function, #line)
        let vc = MusicPlayerViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
