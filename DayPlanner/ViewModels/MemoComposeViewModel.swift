//
//  MemoComposeViewModel.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/18/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

// Input -> title, content, saveButtonTap1
// Output -> saveMemo, dismiss
// ControlProperty: Subject같은 개념, UIElement.rx를 통해서 접근

class MemoComposeViewModel: MemoViewModelType, ViewModelType {
    
    private var memo: Memo
    
    private let bag = DisposeBag()
    private let trigger = PublishSubject<Void>()
    
    private lazy var memoTitleSubject = BehaviorSubject<String>(value: memo.title)
    private lazy var memoContentSubject = BehaviorSubject<String>(value: memo.content)
    private lazy var colorSubject = BehaviorSubject<UIColor>(value: memo.color)
    private lazy var dateSubject = BehaviorSubject(value: memo.date)
    
    override init(storage: MemoStorageType) {
        self.memo = Memo(title: "", content: "")
        super.init(storage: storage)
    }
    
    init(memo: Memo, storage: MemoStorageType) {
        self.memo = memo
        super.init(storage: storage)
    }
    
    struct Input {
        let inputTitle: ControlProperty<String>
        let inputContent: ControlProperty<String>
        let saveButtonTap: ControlEvent<Void>
        let closeButtonTap: ControlEvent<Void>        
        let actionSheetButtonTap: ControlEvent<Void>
        let selectedActionType: Observable<ActionSheetType>
        let colorButtonTap: ControlEvent<Void>
        let selecteColor: Observable<UIColor>
        let datePickerTap: ControlEvent<Void>
        let inputDate: PublishSubject<Date>
    }
    
    struct Output {
        let validate: Driver<Bool>
        let editCompleted: Observable<Void>
        let outputTitle: Driver<String>
        let outputContent: Driver<String>
        let actionButtonTapped: Observable<Void>
        let presentColorPicker: Observable<Void>
        let seleteColor: Driver<UIColor>
        let presentDatePicker: Observable<Void>
        let outputDate: Observable<Date>
    }
    
    func transform(input: Input) -> Output {        
        let validate = Observable.combineLatest(input.inputTitle, input.inputContent)
            .map { !$0.0.isEmpty && !$0.1.isEmpty}
            .asDriver(onErrorJustReturn: false)
            
        input.inputTitle
            .skip(1)
            .bind(to: memoTitleSubject)
            .disposed(by: bag)
        
        input.inputContent
            .skip(1)
            .bind(to: memoContentSubject)
            .disposed(by: bag)
        
        input.saveButtonTap
            .bind(onNext: performUpdate)
            .disposed(by: bag)
        
        input.closeButtonTap
            .bind(to: trigger)
            .disposed(by: bag)
        
        input.selectedActionType
            .bind(onNext: performDelete)
            .disposed(by: bag)
        
        input.selecteColor
            .bind(to: colorSubject)
            .disposed(by: bag)
        
        input.inputDate
            .bind(to: dateSubject)
            .disposed(by: bag)
        
        return Output(validate: validate,
                      editCompleted: trigger,
                      outputTitle: memoTitleSubject.asDriver(onErrorJustReturn: ""),
                      outputContent: memoContentSubject.asDriver(onErrorJustReturn: ""), 
                      actionButtonTapped: input.actionSheetButtonTap.asObservable(),
                      presentColorPicker: input.colorButtonTap.asObservable(),
                      seleteColor: colorSubject.asDriver(onErrorJustReturn: .white),
                      presentDatePicker: input.datePickerTap.asObservable(),
                      outputDate: dateSubject)
    }

    private func performUpdate() {
        do {
            let title = try memoTitleSubject.value()
            let content = try memoContentSubject.value()
            let color = try colorSubject.value()
            let date = try dateSubject.value()
            let memo = Memo(id: memo.id, title: title, content: content, date: date, colorString: color.toHexString())
            
            storage.update(memo: memo)
                .bind(to: trigger)
                .disposed(by: bag)
            
        } catch {
            print("Memo update failed")
        }
    }
    
    private func performDelete(actionType: ActionSheetType) {
        storage.delete(memo: memo)
            .bind(to: trigger)
            .disposed(by: bag)
    }
   
}
