//
//  Language.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 12/29/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

enum Language: String, CaseIterable {
    case ja
    case en
    case zh
    case ko
    case id
    case vi
    case my
    case th
    
    var displayValue: String {
        switch self {
        case .ja:
            return "Japanese"
        case .en:
            return "English"
        case .zh:
            return "Chinese"
        case .ko:
            return "Korean"
        case .id:
            return "Indonesian"
        case .vi:
            return "Vietnamese"
        case .my:
            return "Burmese"
        case .th:
            return "Thai"
        }
    }

}
