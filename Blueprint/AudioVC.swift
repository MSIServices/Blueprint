//
//  AudioVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/18/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import AVFoundation
import Pulsator

class AudioVC: UIViewController {

    @IBOutlet var mainV: MainV!
    @IBOutlet weak var outerBtnV: UIView!
    @IBOutlet weak var middleBtnV: UIView!
    @IBOutlet weak var innerBtnV: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var recordBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var recordBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    let pulsator = Pulsator()
    let playImg = UIImage(named: "play-white")
    let pauseImg = UIImage(named: "pause-white")
    let recorderTimer = Timer!
    let playerTimer = Timer!
    
    var uuid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.minimumTrackTintColor = CHAIN_CREAM
        slider.setThumbImage(UIImage(named: "up-arrow-cream"), for: .normal)
        
        pulsator.numPulse = 6
        pulsator.radius = 300.0
        pulsator.backgroundColor = CHAIN_LIGHT.cgColor
        pulsator.animationDuration = 4.0
        pulsator.pulseInterval = 0
        
        outerBtnV.layer.cornerRadius = outerBtnV.frame.size.width / 2
        outerBtnV.backgroundColor = CHAIN_BLUE_OUTER
        outerBtnV.layer.borderColor = CHAIN_BLUE_BG.cgColor
        outerBtnV.layer.borderWidth = 1.0
        
        middleBtnV.layer.cornerRadius = middleBtnV.frame.size.width / 2
        middleBtnV.backgroundColor = CHAIN_BLUE_INNER
        middleBtnV.layer.borderColor = CHAIN_BLUE_BG.cgColor
        
        innerBtnV.layer.cornerRadius = innerBtnV.frame.size.width / 2
        innerBtnV.backgroundColor = UIColor.black
        innerBtnV.layer.borderColor = UIColor.white.cgColor
        innerBtnV.layer.borderWidth = 1.0
        innerBtnV.layer.superlayer?.insertSublayer(pulsator, below: innerBtnV.layer)
        
        recordBtn.layer.cornerRadius = recordBtn.frame.size.width / 2
        
        AudioManager.shared.setup(self)
        
        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: CHAIN_BLUE), for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pulsator.position = innerBtnV.layer.position
    }

    @IBAction func playAudioBtnPressed(_ sender: Any) {

        if AudioManager.shared.player!.isPlaying {
            
            AudioManager.shared.pause()
            playBtn.setImage(playImg, for: .normal)
            
        } else {
            
            AudioManager.shared.play()
            playBtn.setImage(pauseImg, for: .normal)
        }
    }
    
    @IBAction func recordBtnPressed(_ sender: Any) {
        
        if uuid == nil {
            uuid = UUID().uuidString
        }
        
        if AudioManager.shared.recorder == nil || !pulsator.isPulsating {
            
            descriptionLbl.isHidden = true
            playBtn.isHidden = true
            slider.isHidden = true
            
            pulsator.start()
            
            UIView.animate(withDuration: 1.0, animations: {
                
                self.recordBtnHeight.constant = 29
                self.recordBtnWidth.constant = 29
                self.recordBtn.layer.cornerRadius = 6
            })
            
            if AudioManager.shared.record(fileName: uuid!) {
                
                AudioManager.shared.recorder!.delegate = self
                recorderTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateRecordingTime), userInfo: nil, repeats: true)
                
            } else {
                print("Failed to record.")
            }
        } else {
            
            descriptionLbl.isHidden = false
            playBtn.isHidden = false
            slider.isHidden = false
            
            pulsator.stop()
            
            UIView.animate(withDuration: 1.0, animations: {
                
                self.recordBtnHeight.constant = 58
                self.recordBtnWidth.constant = 58
                self.recordBtn.layer.cornerRadius = 58 / 2
            })
            AudioManager.shared.stopRecording()
            AudioManager.shared.player!.delegate = self
        }
    }
    
    func updateRecordingTime() {
        
        
    }
    
    func backBtnPressed() {
        self.performSegue(withIdentifier: UNWIND_NEW_POST_VC, sender: self)
    }

}

extension AudioVC: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AudioManager did finish recording: \(flag)")
    }
    
    private func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("AUDIO ENCODING ERROR: \(error.debugDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("AudioManager did finish playing: \(flag)")
        
        playBtn.setImage(playImg, for: .normal)
    }
    
    private func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("AUDIO DECODE ERROR: \(error.debugDescription)")
    }

}
