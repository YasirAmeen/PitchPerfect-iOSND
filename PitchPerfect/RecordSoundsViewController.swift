//
//  RecordSoundsViewController.swift
//  PitchPerfectV2
//
//  Created by Rubikkube on 02/04/2021.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate  {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // When the application is start, the stop button will be disable
        // for the user experience prespective
        stopRecordButton.isEnabled = false
    }

    @IBAction func recordButton(_ sender: Any) {
        
        
        configueUI(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopButton(_ sender: Any) {
        
        configueUI(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        
        if flag {
            performSegue(withIdentifier: "stopRecord", sender: recorder.url)
            
        }else {
            print("Recording was not successfull")
            let alert = UIAlertController(title: "Reording Failed", message: "Racording audio failed due to some unknown error.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if (segue.identifier == "stopRecord") {
              let playSoundVC = segue.destination as! PlaySoundsViewController
              let recordedAudioUrl = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioUrl
          }
      }
    
    
    func configueUI(_ isRecording: Bool) {
               stopRecordButton.isEnabled = isRecording
               recordButton.isEnabled = !isRecording
               recordingLabel.text = isRecording ? "Recording ..." : "Tap To Record"
       }
    
}

