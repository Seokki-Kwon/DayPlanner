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
    
    // Input
    struct Input {
        let settingButtonTap: ControlEvent<Void>
        let segmentSeleted: ControlProperty<Int>
        let filterSubject: BehaviorSubject<Filter>
        let viewWillAppear: Observable<Bool>
    }
    
    // Output
    struct Output {
        let goToSettingVC: Observable<Void>
        let movePage: Driver<Int>
        let selecteFilter: Observable<Filter>
        let segmentSelected: Observable<Int>
    }
    
    // Binding
    func transform(input: Input) -> Output {
        
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
                      movePage: input.segmentSeleted.asDriver(),
                      selecteFilter: seleteFilter,
                      segmentSelected: input.segmentSeleted.asObservable()
        )
    }
}
