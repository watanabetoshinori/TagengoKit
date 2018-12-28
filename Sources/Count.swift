//
//  Count.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

struct Count: Codable {
    
    var freeRemained: String
    
    var ticketRemained: String
    
    enum CodingKeys: String, CodingKey {
        case counts
    }
    
    enum CountsCodingKeys: String, CodingKey {
        case freeRemained = "free_remained"
        case ticketRemained = "ticket_remained"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let countsContainer = try container.nestedContainer(keyedBy: CountsCodingKeys.self, forKey: .counts)
        self.freeRemained = try countsContainer.decode(String.self, forKey: .freeRemained)
        self.ticketRemained = try countsContainer.decode(String.self, forKey: .ticketRemained)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var countsContainer = try container.nestedContainer(keyedBy: CountsCodingKeys.self, forKey: .counts)
        try countsContainer.encode(freeRemained, forKey: .freeRemained)
        try countsContainer.encode(ticketRemained, forKey: .ticketRemained)
    }
    
}
