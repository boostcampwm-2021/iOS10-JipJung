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
    let dataSource = ["Relax", "Melody", "Meditation", "Etc"]
    
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
    
    var musicDescriptionView: MusicDescriptionView = {
        let view = MusicDescriptionView()
        view.backgroundColor = .green
        return view
    }()
    
    let maximView: UIView = {
        let view = UIView()
        view.backgroundColor = .magenta
        return view
    }()
    
    let maximTextView: PlayerMaximView? = {
        let view = PlayerMaximView()
        return view
    }()
    
    let playButton: UIButton = {
        let button = SolidButton()
        button.backgroundColor = .gray
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var collectionView: UICollectionView = {
        let layout = LeftAlignCollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.collectionViewLayout = layout
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        return collectionView
    }()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        configureUI()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        playButton.addTarget(self, action: #selector(playButtonTouched(_:)), for: .touchUpInside)
    }
    
    func configureUI() {
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
            make.height.equalTo(view.snp.width).multipliedBy(1.2)
        }
        
        topView.addSubview(musicDescriptionView)
        musicDescriptionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(12)
            make.height.equalTo(105)
        }
        
        musicDescriptionView.tagView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
