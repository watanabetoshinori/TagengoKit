//
//  SpeechSynthesizer.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public class SpeechSynthesizer {
    
    public enum AudioFormat: String, CaseIterable {
        case wav = "WAV"
        case raw = "RAW"
        case adpcm = "ADPCM"
        case speex = "Speex"
    }
    
    public enum AudioEndian: String, CaseIterable {
        case little = "Little"
        case big = "Big"
    }
    
    public enum Gender: String, CaseIterable {
        case unknown
        case female
        case male
    }
    
    public enum SynthesizeLanguage: String, CaseIterable {
        case ja
        case en
        case zh
        case ko
        case id
        case vi
        case my
        case th
    }
    
    let kEndpointURL = "https://sandbox-ss.mimi.fd.ai/speech_synthesis"
    
    var accessToken: String!
    
    // MARK: - Initializing SpeechSynthesizer
    
    public convenience init(accessToken: String) {
        self.init()
        self.accessToken = accessToken
    }
    
    // MARK: - Generate Audio
    
    public func synthesize(text: String, audioFormat: AudioFormat = .wav, audioEndian: AudioEndian = .little, gender: Gender = .unknown, age: Int = 30, isNative: Bool = true, language: SynthesizeLanguage = .en, completionHandler: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: kEndpointURL)!
        
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        let characterSet = CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
        let escapedText = text.addingPercentEncoding(withAllowedCharacters: characterSet)!
        
        let parameters = String(format: "text=%@&audio_format=%@&audio_endian=%@&gender=%@&age=%d&native=%@&lang=%@&engine=nict",
                                escapedText,
                                audioFormat.rawValue,
                                audioEndian.rawValue,
                                gender.rawValue,
                                age,
                                isNative ? "yes" : "no",
                                language.rawValue)
        
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
            
            completionHandler(data, nil)
        }
        
        task.resume()
    }
    
}
