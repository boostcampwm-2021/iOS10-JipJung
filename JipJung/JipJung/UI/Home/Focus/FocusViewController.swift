//
//  FocusViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/07.
//

import UIKit
import RxSwift

class FocusViewController: UIViewController {
    // TODO: 팩토리가 여기 선언되있고 이 부분 코드는 나중에 수정할 예정입니다.
    // TODO: 이 뷰와 관련된 구조체 또한 마찬가지입니다.
    enum Factory {
        static func makeDefaultTimer() -> DefaultFocusViewController {
            return DefaultFocusViewController(viewModel: DefaultFocusViewModel(generateTimerUseCase: GenerateTimerUseCase()))
        }
        static func makePomodoroTimer() -> PomodoroFocusViewController {
            return PomodoroFocusViewController(viewModel: nil)
        }
        static func makeInfinityTimer() -> InfinityFocusViewController {
            let useCase = GenerateTimerUseCase()
            let viewModel = InfinityFocusViewModel(generateTimerUseCase: useCase)
            return InfinityFocusViewController(viewModel: viewModel)
        }
        
    }
    var focusHeaderView: FocusHeaderView
    var focusTimerView: FocusTimerViewable
    var focusStartView: FocusStartViewable
    
    init(focusTimerView: DefaultFocusTimerView, focusStartView: DefaultFocusStartView) {
        self.focusHeaderView = FocusHeaderView()
        self.focusTimerView = focusTimerView
        self.focusStartView = focusStartView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDelegate()
        bind()
        
    }
    
    func configureUI() {
        view.addSubview(focusHeaderView)
        focusHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(60)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        view.addSubview(focusTimerView)
        focusTimerView.snp.makeConstraints { make in
            make.top.equalTo(focusHeaderView.snp.bottom)
            make.height.equalTo(view.snp.width)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let belowView = UIView()
        view.addSubview(belowView)
        belowView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(focusTimerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        belowView.addSubview(focusStartView)
        focusStartView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(120)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func configureDelegate() {
        focusStartView.delegate = self
        focusTimerView.delegate = self
    }
    
    func bind() {
        sub.subscribe(onNext: { [weak self] isRunning in
            if isRunning {
                self?.focusStartView.startFocus()
                self?.focusTimerView.startFocus(with: "0")
            } else {
                self?.focusStartView.endFocus()
                self?.focusTimerView.endFocus()
            }
        }).disposed(by: disposable)
        
        isRunningFirst.asObservable()
          .debug("isRunningFirst") // 로그창에 running true, false 출력
          .flatMapLatest { isRunning in
          isRunning ? Observable<Int>
                  .interval(.seconds(1), scheduler: MainScheduler.init()) : .empty()
          }
          .subscribe(onNext: { [weak self] value in
              guard self?.state == true else {
                  return
              }
              self?.focusTimerView.changeTime(with: "\((self?.time ?? 0) - value)")
          })
          .disposed(by: disposable)
    }
    
    var state: Bool = false {
        didSet {
            sub.onNext(state)
        }
    }
    var time: Int = 100
    var sub = PublishSubject<Bool>()
    let isRunningFirst: BehaviorSubject = BehaviorSubject(value: false)
    // 2. 함수 생성

    var disposable = DisposeBag()
}

extension FocusViewController: FocusStarViewDelegate {
    func startButtonDidClicked() {
        if time < 0 {
            time = 100
        }
        state.toggle()
        
        isRunningFirst.onNext(true)
    }
}

extension FocusViewController: FocusTimerViewDelegate {
    func timeDidSet(with value: Int) {
        print(value)
    }
}
