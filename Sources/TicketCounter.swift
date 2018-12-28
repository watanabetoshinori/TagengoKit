//
//  TicketCounter.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public class TicketCounter {
    
    let kEndpointURL = "https://apis.mimi.fd.ai/v1/applications/counter"
    
    var accessToken: String!
    
    // MARK: - Initializing TicketCount
    
    public convenience init(accessToken: String) {
        self.init()
        self.accessToken = accessToken
    }
    
    // MARK: - Get AccessToken
    
    public func getCount(completionHandler: @escaping (Int?, Error?) -> Void) {
        let url = URL(string: kEndpointURL)!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: .main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(nil, HTTPError.invalidResponse)
                return
            }
            
            if httpResponse.statusCode != 200 {
                completionHandler(nil, HTTPError.invalidStatusCode(httpResponse.statusCode))
                return
            }
            
            guard let data = data else {
                completionHandler(nil, HTTPError.noData)
                return
            }
            
            // For DEBUG
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            
            do {
                let decoder = JSONDecoder()
                let counter = try decoder.decode([Count].self, from: data)
                
                if let ticketRemained = counter.first?.ticketRemained,
                    let count = Double(ticketRemained) {
                    completionHandler(Int(count), nil)
                } else {
                    completionHandler(nil, APIError.error("The `ticketRemained` field not found."))
                }
                
            } catch {
                completionHandler(nil, error)
            }
        }
        
        task.resume()
    }
    
}
