//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by W N Barker on 5/13/15.
//  Copyright (c) 2015 W N Barker. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordedAudio: RecordedAudio!

    @IBOutlet weak var recordingInProgress: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // hide the stop button
        stopButton.hidden = true
        recordButton.enabled = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        //TODO Record the user's voice
        println("in recordAudio")
        recordingInProgress.text = "Recording in Progress"
        recordButton.enabled = false
        stopButton.hidden = false
        
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
                var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()

    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    
        if(flag) {
            
            // save the recording
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!,filePathUrl: recorder.url)
            
            // perform the segue
            self.performSegueWithIdentifier("stoprecording", sender: recordedAudio)
            
        } else {
        
            println("Recording was not seccessful")
            recordButton.enabled = true
            stopButton.hidden = true
        
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stoprecording"){
            
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
            
        }
        
    }

    @IBAction func stopRecording(sender: AnyObject) {
        println("finished recordAudio")
        recordingInProgress.text = "Tap to Record"
        recordButton.enabled = true
        stopButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)

    }
    
}

