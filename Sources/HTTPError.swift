//
//  HTTPError.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public enum HTTPError: Error {
    
    case invalidResponse
    
    case invalidStatusCode(Int)
    
    case noData
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid Response"
            
        case .invalidStatusCode(let code):
            return "Invalid Status Code: \(code)"
            
        case .noData:
            return "No Data"
        }
    }
    
}
