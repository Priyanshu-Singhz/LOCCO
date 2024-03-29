//
//  AudioPageVC.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 04/03/24.
//

import UIKit

class AudioPageVC: UIViewController {
    @IBOutlet var scoreLbl: UILabel!
    @IBOutlet var scoreView: UIView!
    @IBOutlet var scoreLbll: UILabel!
    @IBOutlet var routeView: UIView!
    @IBOutlet var routeLbl: UILabel!
    @IBOutlet var audioImage: UIImageView!
    @IBOutlet var audioTitleLbl: UILabel!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var audioDescriptionLbl: UILabel!
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var pausePlayStackView: UIStackView!
    @IBOutlet var btnPause: UIButton!
    @IBOutlet var playSeekBar: UISlider!
    @IBOutlet var audioPlayedTimeLbl: UILabel!
    @IBOutlet var audioRemainingTimeLabel: UILabel!

    var isPaused = false
    let image = UIImage(named: "slider_dot")
    // Create a button configuration
    var buttonConfig = UIButton.Configuration.plain()
    // Set the insets for the image
    let inset: CGFloat = 8.0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    func setUpUI(){
        playSeekBar.setThumbImage(image, for: .normal)
        playSeekBar.setThumbImage(image, for: .highlighted)
        buttonConfig.imagePlacement = .top
        // Apply the configuration to the button
        btnPlay.configuration = buttonConfig
        btnPause.configuration = buttonConfig
        audioTitleLbl.text = "Schwarzer Berg Restaurant".translated
        audioDescriptionLbl.text = "Restaurant".translated
    }
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func playBtnClicked(_ sender: UIButton) {
        pausePlayStackView.isHidden = false
        btnPlay.isHidden = true
        scoreView.isHidden = true
        routeView.isHidden = false
    }
    @IBAction func pauseOrPlayBtnClicked(_ sender: UIButton) {
        if isPaused {
            resumePlayback()
        } else {
            pausePlayback()
        }
    }
    @IBAction func addStopOverClicked(_ sender: UIControl) {
        print("addStopOverClicked")
    }
    // Function to handle the pause functionality
    func pausePlayback() {
        isPaused = true
        btnPause.setImage(UIImage(named: "Play"), for: .normal)
        btnPause.setTitle("Play", for: .normal)
    }
    // Function to handle the resume play functionality
    func resumePlayback() {
        isPaused = false
        btnPause.setImage(UIImage(named: "Pause"), for: .normal)
        btnPause.setTitle("Pause", for: .normal)
    }
}


