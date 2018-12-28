//
//  RecognizeResult.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

struct RecognizeResult: Codable {
    
    var result: String
    
    var text: String {
        return result.components(separatedBy: "|")[0]
    }
    
    var pronunciation: String {
        return result.components(separatedBy: "|")[1]
    }
    
}
