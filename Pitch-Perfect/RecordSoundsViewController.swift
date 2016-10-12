//
//  RecordSoundsViewController.swift
//  Pitch-Perfect
//
//  Created by Geek on 22/09/15.
//  Copyright (c) 2015 Geek. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
   
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        stopButton.isHidden = true
        recordButton.isEnabled = true
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        recordButton.isEnabled = false
        recordingInProgress.isHidden = false
        stopButton.isHidden = false
        
        //  create filepath i.e .wav file where audio is stored
        
    //    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
    //    let pathArray = [dirPath, recordingName]
    //    let filePath = NSURL.fileURLWithPathComponents(pathArray)
      
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsDirectory.appendingPathComponent(recordingName)
        
        print(filePath)
        
        // settings for AVAudioPlayer. you can give empty dictionary if you do not need to give any sttings.
        let recordSettings:[String : AnyObject] = [
            
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue as AnyObject,
            AVEncoderBitRateKey : 320000 as AnyObject,
            AVNumberOfChannelsKey: 2 as AnyObject,
            AVSampleRateKey : 44100.0 as AnyObject
        ]
        
        // setup audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
                print(filePath)
                audioRecorder = try AVAudioRecorder(url: filePath, settings: recordSettings)
            
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()

        } catch let e as NSError {
            audioRecorder = nil
            print(e.localizedDescription)
        }
        
        // Initialize and prepare the recorder
    
        
    }
    

    
    @IBAction func stopAudio(_ sender: AnyObject) {
        
        recordingInProgress.isHidden = true
        // stop recording the users voice
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag){
            
            // save the Recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            // move to next scene aka perform segue
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
            
        }else{
            print("Recording was not successfull", terminator: "")
            recordButton.isEnabled = true
            stopButton.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
}

