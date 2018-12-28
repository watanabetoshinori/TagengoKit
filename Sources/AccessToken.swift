//
//  AccessToken.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public class AccessToken {
    
    let kEndpointURL = "https://auth.mimi.fd.ai/v2/token"
    
    let kGrantType = "https://auth.mimi.fd.ai/grant_type/application_credentials"
    
    let kScope = [
        "https://apis.mimi.fd.ai/auth/nict-asr/http-api-service",
        "https://apis.mimi.fd.ai/auth/nict-asr/websocket-api-service",
        "https://apis.mimi.fd.ai/auth/nict-tra/http-api-service",
        "https://apis.mimi.fd.ai/auth/nict-tts/http-api-service",
        "https://apis.mimi.fd.ai/auth/applications.r"
        ].joined(separator: ";")
    
    var id: String!
    
    var secret: String!
    
    // MARK: - Initializing AccessToken
    
    public convenience init(id: String, secret: String) {
        self.init()
        self.id = id
        self.secret = secret
    }
    
    // MARK: - Get AccessToken
    
    public func getToken(completionHandler: @escaping (String?, Error?) -> Void) {
        let url = URL(string: kEndpointURL)!
        let parameters = String(format: "grant_type=%@&client_id=%@&client_secret=%@&scope=%@", kGrantType, id, secret, kScope)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        
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
                let token = try decoder.decode(AccessTokenResponse.self, from: data)
                
                switch token.code {
                case 200:
                    completionHandler(token.accessToken, nil)
                default:
                    completionHandler(nil, APIError.error(token.error))
                }
            } catch {
                completionHandler(nil, error)
            }
        }
        
        task.resume()
    }
    
}
