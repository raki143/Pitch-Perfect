//
//  ViewController.swift
//  Pitch-Perfect
//
//  Created by Geek on 22/09/15.
//  Copyright (c) 2015 Geek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingInProgress: UILabel!
   
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
    
        stopButton.hidden = true
        recordButton.enabled = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false
        recordingInProgress.hidden = false
        stopButton.hidden = false
        // TODO: Record the user's voice
        println("in record Audio")
    }

    @IBAction func stopAudio(sender: AnyObject) {
        
        recordingInProgress.hidden = true
        // TODO: stop recording
        println("Recording stopped")
    }
}

