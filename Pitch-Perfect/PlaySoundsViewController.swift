//
//  PlaySoundsViewController.swift
//  Pitch-Perfect
//
//  Created by Geek on 26/09/15.
//  Copyright (c) 2015 Geek. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer : AVAudioPlayer!
    var receivedAudio : RecordedAudio!
    
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try? AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playSlowAudio(_ sender: UIButton) {
        // play audio slowly here
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
        
    }
    
    @IBAction func playFastAudio(_ sender: UIButton) {
        
        // play audio fast here
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    
    @IBAction func stopAudio(_ sender: UIButton) {
        // stop the audio from playing
        audioPlayer.stop()
    }

    @IBAction func playChipmunkAudio(_ sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playDathvaderAudio(_ sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(_ pitch : Float){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
        
        
    }
}
