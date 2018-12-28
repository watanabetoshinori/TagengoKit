//
//  PlayerError.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public enum PlayerError: Error {
    
    case playFailed
    
    public var errorDescription: String? {
        switch self {
        case .playFailed:
            return "AVAudioPlayer play failed."
        }
    }
    
}
