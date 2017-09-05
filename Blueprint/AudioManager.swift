//
//  AudioManager.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/1/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager: NSObject {
    
    static let shared = AudioManager()
    
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var audioUrl: URL?
    var timer: Timer?
    
    func setup() {
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission({ (allowed: Bool) in
             
                if allowed {
                    print("Mic authorized.")
                } else {
                    print("Mic not authorized.")
                }
            })
        } catch {
            print("Failed to set category: \(error.localizedDescription)")
        }
    }
    
    //Start the record session
    func record(fileName: String) -> Bool {
        
        let url = getUserPath().appendingPathComponent(fileName + ".m4a")
        let audioUrl = URL(fileURLWithPath: url.path)
        let recordSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey: 12000.0,
            AVNumberOfChannelsKey: 1
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioUrl, settings: recordSettings)
            recorder?.delegate = self
            recorder?.prepareToRecord()
            recorder?.record()
            
            return true
            
        } catch {
            print("ERROR RECORDING: \(error.localizedDescription)")
            return false
        }
    }
    
    //Stop the recorder
    func stopRecording() {
        self.recorder?.stop()
        self.timer?.invalidate()
    }
    
    func play() {
        player?.play()
    }
    
    //Get the path for the folder we will be saving the file to.
    func getUserPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
}

extension AudioManager: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AudioManager did finish recording")
        print(recorder.url)
        do {
            player = try AVAudioPlayer(contentsOf: recorder.url)
            player?.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("AUDIO ENCODING ERROR: \(error.debugDescription)")
    }
    
}
