//
//  Recorder.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import AVFoundation

public class Recorder {
    
    var recorder: AVAudioRecorder?
    
    public var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    public var path: URL {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = documentDirectoryURL.appendingPathComponent("sample.caf")
        return path
    }
    
    // MARK: - Initialize Recorder
    
    public init() {
        
    }
    
    // MARK: - Start and Stop Recording
    
    public func startRecording() throws {
        let session = AVAudioSession.sharedInstance()
        
        try session.setCategory(.playAndRecord, mode: .default)
        try session.setActive(true)
        
        let format = AVAudioFormat(commonFormat: .pcmFormatInt16  , sampleRate: 16000, channels: 1 , interleaved: false)!
        
        self.recorder = try AVAudioRecorder(url: self.path, format: format)
        
        self.recorder?.prepareToRecord()
        
        self.recorder?.record()
    }
    
    public func stopRecording() {
        self.recorder?.stop()
    }
    
}
