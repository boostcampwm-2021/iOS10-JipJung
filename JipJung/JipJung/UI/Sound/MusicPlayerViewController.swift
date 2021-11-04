//
//  MusicPlayerViewController.swift
//  JipJung
//
//  Created by turu on 2021/11/04.
//

import UIKit

import SnapKit

class MusicPlayerViewController: UIViewController {
    // MARK: - view builder
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        return view
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()
    
    let musicDescriptionView: MusicDescriptionView? = {
        guard let view = Bundle.main.loadNibNamed(
            MusicDescriptionView.identifier,
            owner: self,
            options: nil
        )?.first as? MusicDescriptionView else {
            return nil
        }
        view.backgroundColor = .green
        return view
    }()
    
    let maximView: UIView = {
        let view = UIView()
        view.backgroundColor = .magenta
        return view
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("Play", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setNavigationBar()
        setTopView()
        setBottomView()
    }
    
    // MARK: - constraint 설정 + addSubView
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
        self.view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width)
        }
        
        guard let musicDescriptionView = musicDescriptionView else {
            return
        }

        topView.addSubview(musicDescriptionView)
        musicDescriptionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(12)
            make.height.equalTo(120)
        }
    }
    
    func setBottomView() {
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
        
        bottomView.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(43)
        }
        
        bottomView.addSubview(maximView)
        maximView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(playButton.snp.top).offset(-12)
        }
    }
}
