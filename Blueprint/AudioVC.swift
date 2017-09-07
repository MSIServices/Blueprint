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
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var recordingLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    let pulsator = Pulsator()
    let playImg = UIImage(named: "play-white")
    let pauseImg = UIImage(named: "pause-white")
    
    var recorderTimer: Timer!
    var playerTimer: Timer!
    var uuid: String?
    var dragging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.minimumTrackTintColor = CHAIN_CREAM
        slider.isContinuous = false
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
        addBarButton(imageNormal: "refresh-white", imageHighlighted: nil, action: #selector(refreshBtnPressed), side: .east)
        
        slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderDragged(sender:)), for: .touchDragInside)
        slider.addTarget(self, action: #selector(sliderReleased(sender:)), for: .touchUpInside)
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
        
        AudioManager.shared.recorder = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pulsator.position = innerBtnV.layer.position
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == TEXT_VC {
            
            let vC = segue.destination as! TextVC
            vC.audioUrl = AudioManager.shared.recorder?.url
        }
    }
    
    func sliderDragged(sender: UISlider) {
        
        if AudioManager.shared.player!.isPlaying {
            
            dragging = true
            AudioManager.shared.pausePlayer()
            playerTimer.invalidate()
        }
    }
    
    func sliderReleased(sender: UISlider) {
        
        if dragging {
         
            AudioManager.shared.player!.play()
            playerTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateAudioSlider), userInfo: nil, repeats: true)
            dragging = false
        }
    }
    
    func sliderValueChanged(sender: UISlider) {
        
        AudioManager.shared.player!.currentTime = Double(sender.value) * AudioManager.shared.player!.duration
        durationLbl.text = Helper.formatTimeIntervalWithMinutesAndSeconds(currentTime: AudioManager.shared.player!.duration - AudioManager.shared.player!.currentTime)
    }
    
    func refreshBtnPressed() {
        
        AudioManager.shared.recorder = nil
        slider.isHidden = true
        playBtn.isHidden = true
        stopBtn.isHidden = true
        saveBtn.isHidden = true
        durationLbl.isHidden = true
        recordingLbl.isHidden = true
        descriptionLbl.isHidden = false
        
        pulsator.stop()
        
        UIView.animate(withDuration: 1.0, animations: {
            self.recordBtnHeight.constant = 58
            self.recordBtnWidth.constant = 58
            self.recordBtn.layer.cornerRadius = 58 / 2
        })
        
        if recorderTimer != nil {
            recorderTimer.invalidate()
        }
    }
    
    func backBtnPressed() {
        performSegue(withIdentifier: UNWIND_NEW_POST_VC, sender: self)
    }
    
    func updateRecordingTime() {
        recordingLbl.text = Helper.formatTimeIntervalWithMinutesAndSeconds(currentTime: AudioManager.shared.recorder!.currentTime)
    }
    
    func updateAudioSlider() {

        slider.value = Float(AudioManager.shared.player!.currentTime / AudioManager.shared.player!.duration)
        durationLbl.text = Helper.formatTimeIntervalWithMinutesAndSeconds(currentTime: AudioManager.shared.player!.duration - AudioManager.shared.player!.currentTime)
    }
    
    func showRecordingUI() {
        
        descriptionLbl.isHidden = true
        durationLbl.isHidden = true
        playBtn.isHidden = true
        stopBtn.isHidden = true
        saveBtn.isHidden = true
        slider.isHidden = true
        recordingLbl.isHidden = false
        middleBtnV.layer.borderWidth = 0.0
        
        pulsator.start()
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.recordBtnHeight.constant = 29
            self.recordBtnWidth.constant = 29
            self.recordBtn.layer.cornerRadius = 6
        })
    }
    
    @IBAction func playAudioBtnPressed(_ sender: Any) {

        if AudioManager.shared.player!.isPlaying {
            
            AudioManager.shared.pausePlayer()
            playBtn.setImage(playImg, for: .normal)
            playerTimer.invalidate()
            
        } else {
            
            AudioManager.shared.play()
            playerTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateAudioSlider), userInfo: nil, repeats: true)
            playBtn.setImage(pauseImg, for: .normal)
        }
    }
    
    @IBAction func recordBtnPressed(_ sender: Any) {
        
        if uuid == nil {
            uuid = UUID().uuidString
        }
        
        if AudioManager.shared.recorder == nil {
            
            if AudioManager.shared.record(fileName: uuid!) {
                
                AudioManager.shared.recorder!.delegate = self
                recorderTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateRecordingTime), userInfo: nil, repeats: true)
                showRecordingUI()
                
            } else {
                print("Failed to record.")
            }
        } else {
            
            if !AudioManager.shared.recorder!.isRecording {
                
                AudioManager.shared.resumeRecording()
                recorderTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateRecordingTime), userInfo: nil, repeats: true)
                showRecordingUI()
                
            } else {
                
                saveBtn.isHidden = false
                middleBtnV.layer.borderColor = CHAIN_BLUE_BG.cgColor
                middleBtnV.layer.borderWidth = 1.0
                pulsator.stop()
                
                UIView.animate(withDuration: 1.0, animations: {
                    
                    self.recordBtnHeight.constant = 58
                    self.recordBtnWidth.constant = 58
                    self.recordBtn.layer.cornerRadius = 58 / 2
                })
                AudioManager.shared.pauseRecorder()
                recorderTimer.invalidate()
            }
        }
    }
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        
        AudioManager.shared.player!.currentTime = 0.0
        slider.value = Float(AudioManager.shared.player!.currentTime)
        AudioManager.shared.pausePlayer()
        playerTimer.invalidate()
        durationLbl.text = Helper.formatTimeIntervalWithMinutesAndSeconds(currentTime: AudioManager.shared.player!.duration)
        playBtn.setImage(playImg, for: .normal)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        AudioManager.shared.stopRecording()
        AudioManager.shared.player!.delegate = self
        
        slider.value = 0
        slider.isHidden = false
        stopBtn.isHidden = false
        playBtn.isHidden = false
        durationLbl.isHidden = false
        saveBtn.isHidden = true
        recordingLbl.isHidden = true
        middleBtnV.layer.borderWidth = 0.0
        recorderTimer.invalidate()
        
        durationLbl.text = Helper.formatTimeIntervalWithMinutesAndSeconds(currentTime: AudioManager.shared.player!.duration)
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        if AudioManager.shared.recorder != nil {
            performSegue(withIdentifier: TEXT_VC, sender: self)
        }
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
        playerTimer.invalidate()
        slider.value = 0
    }
    
    private func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("AUDIO DECODE ERROR: \(error.debugDescription)")
    }

}
