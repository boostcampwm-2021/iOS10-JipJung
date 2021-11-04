//
//  MusicPlayerViewController.swift
//  JipJung
//
//  Created by turu on 2021/11/04.
//

import UIKit

import SnapKit

class MusicPlayerViewController: UIViewController {
    // MARK: - View builder -> 임시 코드가 포함됨
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
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(playButtonTouched(_:)), for: .touchUpInside)
        return button
    }()
    
    let maximTextView: PlayerMaximView? = {
        let view = PlayerMaximView()
        return view
    }()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setNavigationBar()
        setTopView()
        setBottomView()
    }
    
    // MARK: - Input vent from views
    @objc func favoriteButtonTouched(_ sender: UIButton) {
        print(#function, #line)
    }
    
    @objc func streamingButtonTouched(_ sender: UIButton) {
        print(#function, #line)
    }
    
    @objc func playButtonTouched(_ sender: UIButton) {
        print(#function, #line)
    }
    
    @objc func backButtonTouched(_ sender: UIButton) {
        print(#function, #line)
    }
}

// MARK: - AddSubView + Constraints
extension MusicPlayerViewController {
    func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .done,
            target: self,
            action: #selector(backButtonTouched(_:))
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTouched(_:))
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
        
        guard let maximTextView = maximTextView else {
            return
        }
        
        maximView.addSubview(maximTextView)
        maximTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
