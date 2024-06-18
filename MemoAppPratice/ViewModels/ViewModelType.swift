//
//  ViewModelType.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import Foundation

// ViewModel이 상속하는 클래스
class ViewModelType {
    let storage: MemoStorageType
    
    init(storage: MemoStorageType) {
        self.storage = storage
    }
}
