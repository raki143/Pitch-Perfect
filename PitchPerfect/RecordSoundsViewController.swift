//
//  RecordViewController.swift
//  PitchPerfect
//


import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    let audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        stopRecordingButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Record and Audio Buttons Pressed

    @IBAction func RecordAudioButtonPressed(sender: AnyObject)
    {
        configureRecrodingButtons(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecordingButtonPressed(sender: AnyObject)
    {

        configureRecrodingButtons(false)
        audioRecorder.stop()
        print(audioRecorder.currentTime)
        try! audioSession.setActive(false)
    }
    
    func configureRecrodingButtons(isRecording: Bool){
        recordingLabel.text = isRecording ? "Recording in progress" : "Tap to record"
        recordButton.enabled = isRecording ? false: true
        stopRecordingButton.enabled = isRecording ? true : false
    }
    
    // MARK: - Perform Segue
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        print("AVAudioRecorder Finished Recording ")
        if (flag) {
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }else{
            print("Recorded audio saving is failed")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "stopRecording")
        {
            let playsoundsVC = segue.destinationViewController as! playSoundViewController
            let recordedAudioURL = sender as! NSURL
            playsoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

