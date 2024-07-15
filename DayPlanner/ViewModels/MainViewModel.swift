//
//  MainPageViewModel.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: MemoViewModelType, ViewModelType {
    private let bag = DisposeBag()
    
    struct Input {
        let settingButtonTap: ControlEvent<Void>
        let segmentSeleted: ControlProperty<Int>
        let titleTap: ControlEvent<Void>
        let filterSubject: BehaviorSubject<Filter>
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        let goToSettingVC: Observable<Void>
        let showMenu: Observable<Void>
        let movePage: Driver<Int>
        let tileTapped: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        // title이 Tap되고 segementIndex가 0인경우 이벤트를 방출
        
        let showMenuObservable = input.titleTap
            .withLatestFrom(input.segmentSeleted)
            .filter { $0 == 0 }
            .map { _ -> Void in  }
        
        Observable.combineLatest(input.filterSubject, input.viewWillAppear)
            .map { $0.0 }
            .subscribe(onNext: { [weak self] filter in
                guard let self = self else { return }
                switch filter {
                case .all:                    
                    storage.memoList(.all)
                case .last:
                    storage.memoList(.last)
                case .upcomming:
                    storage.memoList(.upcomming)
                }
            })
            .disposed(by: bag)
        
        
        return Output(goToSettingVC: input.settingButtonTap.asObservable(),
                      showMenu: showMenuObservable,
                      movePage: input.segmentSeleted.asDriver(),
                      tileTapped: input.titleTap)
    }
}
