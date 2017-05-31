//
//  PitchViewController.swift
//  PitchPerfect3
//
//  Created by Jon Nelson1 on 5/31/17.
//  Copyright © 2017 Jon Nelson. All rights reserved.
//

import UIKit
import AVFoundation

class PitchViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    var receivedAudio: URL?
    var audioPlayer : AVAudioPlayer?
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode=AVAudioPlayerNode()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        do{
        audioFile = try AVAudioFile(forReading: receivedAudio!)
        }
        catch {
            audioFile=nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup(){
        do {
            try audioPlayer = AVAudioPlayer(contentsOf:
                (receivedAudio)!)
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
        }

    }
    func commonAudioFunction(audioChangeNumber: Float, typeOfChange: String){
        var audioPlayerNode=AVAudioPlayerNode()
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioEngine.attach(audioPlayerNode)
        
        let changeAudioUnitTime = AVAudioUnitTimePitch()
        
        if (typeOfChange == "rate") {
            
            changeAudioUnitTime.rate = audioChangeNumber
            
        } else {
            changeAudioUnitTime.pitch = audioChangeNumber
        }
        audioEngine.attach(changeAudioUnitTime)
        audioEngine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        audioEngine.connect(changeAudioUnitTime, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do{
        try audioEngine.start()
        }
        catch{
            
        }

        audioPlayerNode.play()
        
    }
    @IBAction func playButton(_ sender: Any) {
       setup()
        audioPlayer?.play()
    }
    
    @IBAction func fastButton(_ sender: Any) {
        setup()
        audioPlayer?.enableRate = true
        audioPlayer?.rate = 2.0
        audioPlayer?.play()
    }
    
    @IBAction func slowButton(_ sender: Any) {
        setup()
        audioPlayer?.enableRate = true
        audioPlayer?.rate = 0.5
        audioPlayer?.play()
    }
    
    @IBAction func highPitchButton(_ sender: Any) {
        commonAudioFunction(audioChangeNumber: 1000, typeOfChange: "pitch")
    }
    @IBAction func lowPitchButton(_ sender: Any) {
        commonAudioFunction(audioChangeNumber: -1000, typeOfChange: "pitch")
    }
    @IBAction func stop(_ sender: Any) {
        audioPlayer?.stop()
        audioPlayerNode.stop()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
