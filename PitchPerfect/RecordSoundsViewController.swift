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
        print("Record Button is pressed.")
        recordingLabel.text = "Recording in progress"
        stopRecordingButton.enabled = true
        recordButton.enabled = false
        
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
        print("Recording has been stopped.")
        recordingLabel.text = "Tap to Record"
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        audioRecorder.stop()
        print(audioRecorder.currentTime)
        try! audioSession.setActive(false)
    }
    
    
    // MARK: - Perform Segue
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        print("AVAudioRecorder Finished Recording ")
        if (flag) {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
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

