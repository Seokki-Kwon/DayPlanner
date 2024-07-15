//
//  MemoStorageType.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import Foundation
import RxSwift

protocol MemoStorageType {    
    func memoList(_ filter: Filter) -> Void
    var filterdData: BehaviorSubject<[Memo]> { get set }
    @discardableResult
    func createMemo(memo: Memo) -> Observable<Void>
    @discardableResult
    func updateMemo(memo: Memo) -> Observable<Void>
    @discardableResult
    func deleteMemo(memo: Memo) -> Observable<Void>
    @discardableResult
    func fetchMemos() -> Observable<[Memo]>    
}
