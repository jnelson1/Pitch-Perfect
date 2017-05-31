//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Jon Nelson1 on 5/30/17.
//  Copyright © 2017 Jon Nelson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    @IBOutlet weak var recordButton: UIButton!

    @IBOutlet weak var stopButton: UIButton!
    var audioRecorder: AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier=="stopRecording"){
            let pitchVC: PitchViewController=segue.destination as!PitchViewController
            var data: URL=audioRecorder!.url
            pitchVC.receivedAudio=data
        }
    }

    @IBAction func RecordSound(_ sender: Any) {
        audioRecorder?.record()
    }
    
    @IBAction func StopRecord(_ sender: Any) {
        audioRecorder?.stop()
        }
    }




