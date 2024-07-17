//
//  MemoStorageType.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    @discardableResult
    func create(memo: Memo) -> Observable<Void>
    @discardableResult
    func update(memo: Memo) -> Observable<Void>
    @discardableResult
    func delete(memo: Memo) -> Observable<Void>
    @discardableResult
    func fetch() -> Observable<[Memo]>    
}
