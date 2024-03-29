//
//  MiniPlayerView.swift
//  LOCCO
//
//  Created by Mac on 04/03/24.
//

import UIKit

class MiniPlayerView: UIView {

    //MARK: - Outlets
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var MusicIcon: UIImageView!
    @IBOutlet weak var LblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var musicProgress: UIProgressView!
    
    //MARK: - Properties
    var closeAction: (() -> Void)?
    var handlerOpenFullPlayer:(() -> ())? = nil
    static var shared: MiniPlayerView? = nil
    class func sharedInstance() -> MiniPlayerView {
        if shared == nil {
            shared = UIView.fromNib()
        }
        return shared!
    }
    
    //MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func closePopup() {
        UIView.animate(withDuration: 0.25, animations: {
            MiniPlayerView.sharedInstance().popView.transform = CGAffineTransform(translationX: 0, y: MiniPlayerView.sharedInstance().popView.bounds.height)
        }, completion: { (_) in
            MiniPlayerView.sharedInstance().removeFromSuperview()
            MiniPlayerView.shared = nil
        })
    }
    
    class func showMiniPlayerViewWithHandlers(mainView: UIView, closeHandler: (()->Void)? = nil) {
        let window = UIApplication.shared.firstKeyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        mainView.addSubview(MiniPlayerView.sharedInstance())
        MiniPlayerView.sharedInstance().frame = CGRect(x: 0, y: UIScreen.main.bounds.height - MiniPlayerView.sharedInstance().popView.bounds.height - bottomPadding, width: UIScreen.main.bounds.width, height: MiniPlayerView.sharedInstance().popView.bounds.height + bottomPadding)
        
        MiniPlayerView.sharedInstance().popView.transform = CGAffineTransform(translationX: 0, y: MiniPlayerView.sharedInstance().popView.bounds.height + bottomPadding)
        UIView.animate(withDuration: 0.25) {
            MiniPlayerView.sharedInstance().popView.transform = CGAffineTransform.identity
        }
        
        MiniPlayerView.sharedInstance().closeAction = closeHandler
    }
    
    //MARK: - Actions
    @IBAction func closeBtn_Action(_ sender: UIButton) {
        closePopup()
        closeAction?()
    }
    @IBAction func playBtnClicked(_ sender: UIButton) {
        self.handlerOpenFullPlayer?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("[MiniPlayerView] touchesEnded")
        self.handlerOpenFullPlayer?()
    }

    
}
