//
//  AccessTokenResponse.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

struct AccessTokenResponse: Codable {
    
    var accessToken: String
    
    var code: Int
    
    var error: String
    
}
