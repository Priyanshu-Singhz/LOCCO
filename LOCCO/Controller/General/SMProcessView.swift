//
//  SMProcessView.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 06/03/24.
//

import UIKit
import Lottie

class SMProcessView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    //MARK: - Lifecycle
    static let shared = SMProcessView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SMProcessView", owner: self, options: nil)
        contentView.fixInView(self)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
//        animationView.animationSpeed = 0.5
    }
    
    //MARK: - Helper
    
    func start()  {
        self.frame = UIApplication.shared.firstKeyWindow?.bounds ?? .zero
        UIApplication.shared.firstKeyWindow?.addSubview(self)
        self.animationView.play()
        UIView.animate(withDuration: 0.2) {
            self.contentView.backgroundColor = UIColor.appDarkBlue.withAlphaComponent(0.7)
        }
    }
    
    func stop() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.backgroundColor = UIColor.clear
        }) { finish in
            if finish {
                self.removeFromSuperview()
                self.animationView.stop()
            }
        }
    }
}
