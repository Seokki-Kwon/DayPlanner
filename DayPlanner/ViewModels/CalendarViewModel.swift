//
//  CalendarViewModel.swift
//  DayPlanner
//
//  Created by 석기권 on 6/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CalendarViewModel: MemoViewModelType, ViewModelType {
    
    private var memoList: Observable<[Memo]> {
        return store
    }
    
    private let bag = DisposeBag()
    private let currentMonthMemo = BehaviorRelay<[Memo]>(value: [])
    private let currentDayMemo = BehaviorRelay<[Memo]>(value: [])
    
    struct Input {
        let seletedDate: BehaviorRelay<Date>
        let viewWillAppear: Observable<Bool>
    }
    struct Output {
        let seletedDate: Observable<Date>
        let currentMonthMemo: Observable<[Memo]>
    }
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMapLatest({ (owner, _) -> Observable<[Memo]>  in
                owner.storage.fetch()
            })
            .bind(onNext: store.onNext(_:))
            .disposed(by: bag)
        
        Observable.combineLatest(input.seletedDate, memoList, input.viewWillAppear)
            .map { (date, memoArray, _) in
                memoArray.filter { $0.date.checkCurrnetMotnh(date: date)}
            }
            .bind(to: currentMonthMemo)
            .disposed(by: bag)
        
        return Output(
            seletedDate: input.seletedDate.asObservable(),
            currentMonthMemo: currentMonthMemo.asObservable()
        )
    }
}
