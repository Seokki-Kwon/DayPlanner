//
//  ViewModelType.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import Foundation
import RxSwift
// ViewModel이 상속하는 클래스
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output    
}

class MemoViewModelType {
    let storage: MemoStorageType
    let store: BehaviorSubject<[Memo]>
    
    init(storage: MemoStorageType) {
        self.storage = storage
        self.store = BehaviorSubject(value: [])
    }
    
    // 같은 저장소를 공유해야 하는경우
    init(storage: MemoStorageType, store: BehaviorSubject<[Memo]>) {
        self.storage = storage
        self.store = store
    }
}
