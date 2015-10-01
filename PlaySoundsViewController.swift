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
        
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playSlowAudio(sender: UIButton) {
        // play audio slowly here
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
        
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        
        // play audio fast here
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        // stop the audio from playing
        audioPlayer.stop()
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playDathvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch : Float){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
        
        
    }
}
