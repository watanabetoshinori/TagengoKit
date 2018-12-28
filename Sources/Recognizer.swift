//
//  Recognizer.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public class Recognizer {
    
    public enum RecognizeLanguage: String, CaseIterable {
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
        
        var languageSeparator: String {
            switch self {
            case .en, .fr, .es, .id, .vi:
                return " "
            default:
                return ""
            }
        }
    }
    
    let kEndpointURL = "https://sandbox-sr.mimi.fd.ai/"
    
    var accessToken: String!
    
    // MARK: - Initializing Recognizer
    
    public convenience init(accessToken: String) {
        self.init()
        self.accessToken = accessToken
    }
    
    // MARK: - Recognize Audio
    
    public func recognize(audio: URL, language: RecognizeLanguage = .ja, completionHandler: @escaping (String?, Error?) -> Void) {
        do {
            let data = try Data(contentsOf: audio)
            recognize(audio: data, language: language, completionHandler: completionHandler)
        } catch {
            completionHandler(nil, error)
        }
    }
    
    public func recognize(audio: Data, language: RecognizeLanguage = .ja, completionHandler: @escaping (String?, Error?) -> Void) {
        let url = URL(string: kEndpointURL)!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("audio/x-pcm;bit=16;rate=16000;channels=1", forHTTPHeaderField: "Content-Type")
        request.setValue(language.rawValue, forHTTPHeaderField: "x-mimi-input-language")
        request.setValue("nict-asr", forHTTPHeaderField: "x-mimi-process")
        request.httpMethod = "POST"
        request.httpBody = audio
        
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
                let response = try decoder.decode(RecognizeResponse.self, from: data)
                
                let textList = response.response.reduce(into: [String](), { $0.append($1.text) })
                let text = textList.joined(separator: language.languageSeparator)
                
                completionHandler(text, nil)
                
            } catch {
                completionHandler(nil, error)
            }
        }
        
        task.resume()
    }
    
}
