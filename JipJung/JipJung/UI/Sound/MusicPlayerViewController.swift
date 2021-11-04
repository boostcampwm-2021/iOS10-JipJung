//
//  MusicPlayerViewController.swift
//  JipJung
//
//  Created by turu on 2021/11/04.
//

import UIKit
import SnapKit

class MusicPlayerViewController: UIViewController {
    
    let topView = UIView()
    let bottomView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        setNavigationBar()
        setTopView()
        setBottomView()
    }
    
    func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    func setTopView() {
        topView.backgroundColor = .purple
        self.view.addSubview(topView)
        
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width)
        }
    }
    
    func setBottomView() {
        bottomView.backgroundColor = .cyan
        self.view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
    }
}
