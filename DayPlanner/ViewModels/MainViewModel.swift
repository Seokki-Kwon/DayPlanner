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
        let titleTapped: ControlEvent<Void>
        let selecteFilter: Observable<Filter>
    }
    
    func transform(input: Input) -> Output {
        // title이 Tap되고 segementIndex가 0인경우 이벤트를 방출
    
        let showMenuObservable = input.titleTap
            .withLatestFrom(input.segmentSeleted)
            .filter { $0 == 0 }
            .map { _ -> Void in  }
        
        let filterObservable = Observable.combineLatest(input.filterSubject, input.viewWillAppear)
            .share()
        
        let seleteFilter = filterObservable.map { $0.0 }

        // 선택된 필터에 따라서 store를 변경        
        filterObservable
            .map { $0.0 }
            .subscribe(onNext: { [weak self] filter in
                
                guard let self = self else { return }
                
                switch filter {
                case .all:
                    storage.fetch()                                   
                        .bind(onNext: store.onNext(_:))
                        .disposed(by: bag)
                case .last:
                    storage.fetch()
                        .flatMapLatest { array -> Observable<[Memo]> in
                            Observable.just( array.filter {
                                $0.date.checkBeforeToday() == .orderedAscending ||
                                $0.date.compare(Date()) == .orderedAscending
                            })
                        }
                        .bind(onNext: store.onNext(_:))
                        .disposed(by: bag)
                case .upcomming:
                    storage.fetch()
                        .flatMapLatest { array -> Observable<[Memo]> in
                            Observable.just( array.filter {
                                $0.date.checkBeforeToday() == .orderedDescending ||
                                $0.date.compare(Date()) == .orderedDescending
                            })
                        }
                        .bind(onNext: store.onNext(_:))
                        .disposed(by: bag)
                }
            })
            .disposed(by: bag)
        
        return Output(goToSettingVC: input.settingButtonTap.asObservable(),
                      showMenu: showMenuObservable,
                      movePage: input.segmentSeleted.asDriver(),
                      titleTapped: input.titleTap,
                      selecteFilter: seleteFilter )
    }
}
