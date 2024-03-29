//
//  OnBoardingVC.swift
//  Onboarding
//
//  Created by Zignuts Technolab on 12/02/24.
//

import UIKit
import JXPageControl

class OnBoardingVC: UIViewController {
    
    @IBOutlet weak var videoPlayer: ASPVideoPlayerView!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var collectionMain: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var advancePageControll: JXPageControlScale!
    fileprivate var vmOnboarding = ViewModelOnboarding()
    fileprivate var currentPage:Int = 0 {
        didSet {
            updateUI()
        }
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        updateUI()
    }
    
    // MARK: - Actions
    @IBAction func pageChangedBtnClicked(_ sender: UIPageControl) {
        currentPage = sender.currentPage
    }
    
    @IBAction func btnSkipClicked(_ sender: UIButton) {
        navigateToWelComePage()
    }
    
    @IBAction func btnStartClicked(_ sender: Any) {
        navigateToWelComePage()
    }
    
    @IBAction func btnNextClicked(_ sender: UIButton) {
        let nextPage = currentPage + 1
        if nextPage < vmOnboarding.arrOnBoardData.count {
            currentPage = nextPage
        }
    }
    
    @IBAction func previousBtnClicked(_ sender: UIButton) {
        let previousPage = currentPage - 1
        if previousPage >= 0 {
            currentPage = previousPage
        }
    }
    
    // MARK: - Helper
    /// Update UI of slider. Sets according current page
    func updateUI() {
//        advancePageControll.setPage(currentPage)
        advancePageControll.progress = CGFloat(currentPage) * view.bounds.width
        btnPrevious.isHidden =  currentPage == 0 ? true : false
        let isLastPage = currentPage == (vmOnboarding.arrOnBoardData.count - 1)
        btnStart.isHidden = isLastPage ? false : true
        btnNext.isHidden = isLastPage ? true : false
        btnSkip.isHidden = isLastPage  ? true : false
        let videoName = vmOnboarding.arrOnBoardData[currentPage].videoUrl
        playVideo(url: videoName)
        collectionMain.scrollRectToVisible(CGRect(origin: CGPoint(x: (Int(collectionMain.frame.width) * currentPage), y: 0), size: collectionMain.frame.size), animated: true)
    }
    func initialSetup() {
        btnSkip.setTitle("initial_slider_skip".translated, for: .normal)
        btnNext.setTitle("initial_slider_next".translated, for: .normal)
        btnPrevious.setTitle("initial_slider_previous".translated, for: .normal)
        btnStart.setTitle("initial_slider_start".translated, for: .normal)
        
        collectionMain.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        advancePageControll.progress = 0.0
    }
    
    func navigateToWelComePage() {
        if let welCome = AppStoryboard.main.viewController(WelcomePageVC.self) {
            self.navigationController?.pushViewController(welCome, animated: true)
        }
    }
}

extension OnBoardingVC {
    /// Play video using given url
    /// - Parameters:
    ///     - url: it should be name of video from main bundle
    func playVideo(url: String) {
        if let videoURL = Bundle.main.url(forResource: url, withExtension: "mp4") {
            //if let videoURL = URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") {
            videoPlayer.videoURL = videoURL
            videoPlayer.gravity = .aspectFill
            videoPlayer.volume = 0.0
            videoPlayer.shouldLoop = true
            videoPlayer.startPlayingWhenReady = true
        } else {
            print("Error: Video file not found.")
        }
    }
}
// MARK: - Colectionview Methods
extension OnBoardingVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vmOnboarding.arrOnBoardData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setupCell(vmOnboarding.arrOnBoardData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.bounds.width
        advancePageControll.progress = progress
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if pageIndex >= 0 && pageIndex < vmOnboarding.arrOnBoardData.count {
            currentPage = pageIndex
        }
    }
}
