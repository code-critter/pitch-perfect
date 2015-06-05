//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by W N Barker on 5/18/15.
//  Copyright (c) 2015 W N Barker. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        
        // used to route the sound output to the speakers - Thanks to the following for incite on how to do this
        // Apple documentation talked about setting the categories, but never really gave examples on how to do
        // this with modes as well.
        // http://stackoverflow.com/questions/1022992/how-to-get-avaudioplayer-output-to-the-speaker
        
        var asession = AVAudioSession.sharedInstance()
        asession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions:AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func playSlowButton(sender: AnyObject) {
        
        
        println("trying to play slow sound")
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = 0.5
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.play()

        
    }
    
    @IBAction func playFastButton(sender: AnyObject) {
        
        println("trying to play fast sound")
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = 1.5
        
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.play()

        
    }
    
    
    @IBAction func stopAudio(sender: AnyObject) {
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        
        audioEngine.stop()
        audioEngine.reset()
        
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthVaderSound(sender: AnyObject) {
        
        playAudioWithVariablePitch(-1000)
        
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        
        audioEngine.stop()
        audioEngine.reset()
        
        if pitch == 1000 {
         
            println("trying to play chipmunk sound")
            
        } else if pitch == -1000 {
            
            println("trying to play vader sound")
            
        } else {
            
            println("trying to variable pitch sound")
        }
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect: AVAudioUnitTimePitch = AVAudioUnitTimePitch()
        
        // Set the pitch-shift amount (100 cents = 1 semitone)
        changePitchEffect.pitch = pitch // +1 semitone
        
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to:changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to:audioEngine.outputNode, format:nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime:nil, completionHandler:nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    
}
