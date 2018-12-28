//
//  Player.swift
//  TagengoKit
//
//  Created by Watanabe Toshinori on 12/22/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import AVFoundation

public class Player {
    
    var player: AVAudioPlayer!
    
    // MARK: - Initialize Player
    
    public init() {
        
    }
    
    // MARK: - Play and Stop audio
    
    public func play(audio: URL) throws {
        let data = try Data(contentsOf: audio)
        try play(audio: data)
    }
    
    public func play(audio: Data) throws {
        player = try AVAudioPlayer(data: audio)
        if player.play() == false {
            throw PlayerError.playFailed
        }
    }
    
    public func stop() {
        player.stop()
    }
    
    // MARK: - Append WAV Header
    
    public func appendWavHeader(to audioData: Data) -> Data {
        let sampleRate: Int32 = 16000
        let bitPerSample: Int16 = 16
        let channelN: Int16 = 1
        let headerSize = 44
        
        let riff = "RIFF"
        let fileSize = Int32(headerSize + audioData.count - 8)
        let wave = "WAVE"
        let fmt = "fmt "
        
        let byteN: Int32 = 16
        let formatId: Int16 = 1
        let dataSpeed = sampleRate * Int32(bitPerSample / 2) * Int32(channelN)
        let blockSize = (bitPerSample / 2) * channelN
        let data = "data"
        let waveSize = Int32(audioData.count)
        
        var d = Data()
        d.append(riff.data(using: .utf8)!)
        d.append(self.data(from: fileSize))
        d.append(wave.data(using: .utf8)!)
        d.append(fmt.data(using: .utf8)!)
        d.append(self.data(from: byteN))
        d.append(self.data(from: formatId))
        d.append(self.data(from: channelN))
        d.append(self.data(from: sampleRate))
        d.append(self.data(from: dataSpeed))
        d.append(self.data(from: blockSize))
        d.append(self.data(from: bitPerSample))
        d.append(data.data(using: .utf8)!)
        d.append(self.data(from: waveSize))
        d.append(audioData)
        
        return d
    }
    
    func data(from value: Int16) -> Data {
        var val = value
        return Data(bytes: &val, count: MemoryLayout.size(ofValue: val))
    }
    
    func data(from value: Int32) -> Data {
        var val = value
        return Data(bytes: &val, count: MemoryLayout.size(ofValue: val))
    }
    
}
