//
//  Memo.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import Foundation
import UIKit

struct Memo {
    var id: String = UUID().uuidString
    var title: String
    var content: String   
    let date = Date()
}
