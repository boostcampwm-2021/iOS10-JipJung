//
//  HomeViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//

import UIKit

import SnapKit

class HomeViewController: UIViewController {
    private let mainScrollView = UIScrollView()
    private let mainScrollContentsView = UIView()
    private let topView = UIView()
    private let bottomView = UIView()
    
    private let topViewHeight = 120
    private let bottomViewHeight = 800
    private let topBottomYGap = 450
    private let statusHeight = 47
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureMainScrollView()
        configureTopView()
        configureBottomView()
    }
    
    private func configureMainScrollView() {
        mainScrollView.delegate = self
        
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainScrollView.addSubview(mainScrollContentsView)
        mainScrollContentsView.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
    
    private func configureTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(topViewHeight)
        }
        
        let helloLabel = UILabel()
        helloLabel.text = "Hi, friend"
        helloLabel.textColor = .black
        helloLabel.font = .preferredFont(forTextStyle: .title3)
        
        topView.addSubview(helloLabel)
        helloLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(topView.snp.centerY).offset(-4)
        }
        
        let nowStateLabel = UILabel()
        nowStateLabel.text = "Good Day"
        nowStateLabel.textColor = .black
        nowStateLabel.font = .preferredFont(forTextStyle: .title1)
        
        topView.addSubview(nowStateLabel)
        nowStateLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.centerY)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func configureBottomView() {
        bottomView.backgroundColor = .gray
        mainScrollContentsView.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topBottomYGap + topViewHeight)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(bottomViewHeight)
        }
        
        let focusButtonStackView = UIStackView()
        focusButtonStackView.axis = .horizontal
        focusButtonStackView.alignment = .center
        focusButtonStackView.distribution = .equalSpacing
        bottomView.addSubview(focusButtonStackView)
        focusButtonStackView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(80)
        }
        
        let focus0 = UIView()
        focus0.backgroundColor = .black
        focus0.snp.makeConstraints {
            $0.width.height.equalTo(60)
        }
        
        let focus1 = UIView()
        focus1.backgroundColor = .black
        focus1.backgroundColor = .black
        focus1.snp.makeConstraints {
            $0.width.height.equalTo(60)
        }
        
        let focus2 = UIView()
        focus2.backgroundColor = .black
        focus2.backgroundColor = .black
        focus2.snp.makeConstraints {
            $0.width.height.equalTo(60)
        }
        
        let focus3 = UIView()
        focus3.backgroundColor = .black
        focus3.backgroundColor = .black
        focus3.snp.makeConstraints {
            $0.width.height.equalTo(60)
        }
        
        focusButtonStackView.addArrangedSubview(focus0)
        focusButtonStackView.addArrangedSubview(focus1)
        focusButtonStackView.addArrangedSubview(focus2)
        focusButtonStackView.addArrangedSubview(focus3)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentsOffsetY = scrollView.contentOffset.y
        let currentTopBottomYGap = topBottomYGap - (Int(currentContentsOffsetY) + statusHeight)
        topView.snp.updateConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(min(0, currentTopBottomYGap))
        }
    }
}
