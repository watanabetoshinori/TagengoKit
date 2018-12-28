//
//  Translator.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public class Translator {
    
    public enum TranslateLanguage: String, CaseIterable {
        case ja
        case en
        case es
        case fr
        case id
        case ko
        case my
        case th
        case vi
        case zh
    }
    
    let kEndpointURL = "https://sandbox-mt.mimi.fd.ai/machine_translation"
    
    var accessToken: String!
    
    // MARK: - Initializing Transrator
    
    public convenience init(accessToken: String) {
        self.init()
        self.accessToken = accessToken
    }
    
    // MARK: - Translate text
    
    public func translate(text: String, from sourceLanguage: TranslateLanguage = .ja, to targetLanguage: TranslateLanguage = .en, completionHandler: @escaping (String?, Error?) -> Void) {
        let url = URL(string: kEndpointURL)!
        
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        let characterSet = CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
        let escapedText = text.addingPercentEncoding(withAllowedCharacters: characterSet)!
        
        let parameters = String(format: "text=%@&source_lang=%@&target_lang=%@", escapedText, sourceLanguage.rawValue, targetLanguage.rawValue)
        
        var request = URLRequest(url: url)
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
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
            
            let result = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String]
            completionHandler(result?.first ?? "", nil)
        }
        
        task.resume()
    }
    
}
