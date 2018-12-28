//
//  APIError.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public enum APIError: Error, LocalizedError {
    
    case error(String)
    
    public var errorDescription: String? {
        switch self {
        case .error(let error):
            return "API Error: \(error)"
        }
    }
    
}
