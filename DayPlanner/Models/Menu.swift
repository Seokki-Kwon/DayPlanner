//
//  Menu.swift
//  DayPlanner
//
//  Created by 석기권 on 7/3/24.
//

import Foundation

enum Menu: CaseIterable {
    case contact
    case openSource
    
    var title: String {
        switch self {
        case .contact:
            "문의하기"
        case .openSource:
            "오픈소스"
        }
    }
}
