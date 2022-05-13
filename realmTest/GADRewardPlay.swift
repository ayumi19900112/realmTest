

import UIKit
import GoogleMobileAds
import PKHUD
//動画広告のView
protocol dismissPlayActionDelegate {
    func resultWithPlayRewarded(result:Int,senderTag:Int)
    func ErrorLoadWithPlay(senderTag: Int)
}

class GADRewardPlay: UIViewController {
    
    private var rewardedAd:GADRewardedAd?
    private var dismissButton = UIButton()
    private var resultNumber:Int = 0
    var senderTag : Int?
    var isComplete : Bool = false
    
    var dismissPlayActionDelegate : dismissPlayActionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Rewqrd:",senderTag ?? 00000)
        setupButton()
        HUD.show(.progress)
        let request = GADRequest()
        
        GADRewardedAd.load(withAdUnitID: videoTestCode
                           , request: request) { (ad, err) in
            if let error = err {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                HUD.flash(.error)
                self.isComplete = true
                self.dismiss()
                
                return
            }
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            print("動画準備完了")
            HUD.hide()
            self.showRewardedAd()
        }
    }
    private func setupButton(){
        view.addSubview(dismissButton)
        dismissButton.setImage(UIImage(named: "cross"), for: .normal)
        dismissButton.anchor(top:view.topAnchor,
                             right: view.rightAnchor,
                             width: 50,
                             height: 50,
                             topPadding: 50,
                             rightPadding: 50)
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    @objc private func dismissAction(){
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:報酬を与える
    private func showRewardedAd() {
        
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self,
                       userDidEarnRewardHandler: { [self] in
                let reward = ad.adReward
                print("reward : ",reward)
                // TODO: Reward the user.
                print("報酬を与えます")
                self.isComplete = true
                self.resultNumber += 10
            }
            )
        } else {
            print("Ad wasn't ready")
            self.resultNumber += -10
        }
    }
    //MARK:遷移して戻る
    private func dismiss(){
        
        dismiss(animated: true) {
            print("Dismiss Action Start")
            self.dismissPlayActionDelegate?.resultWithPlayRewarded(result:self.resultNumber,senderTag:self.senderTag ?? 0)
            self.dismiss(animated: true, completion: nil)
            if self.isComplete{
                self.dismissPlayActionDelegate?.resultWithPlayRewarded(result:self.resultNumber,senderTag:self.senderTag ?? 0)
            }else{
                self.dismissPlayActionDelegate?.ErrorLoadWithPlay(senderTag: self.senderTag ?? 0)
            }
        }
    }
}
extension GADRewardPlay : GADFullScreenContentDelegate {
    /// Tells the delegate that the rewarded ad was presented.
    /*func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
     print("Rewarded ad presented. ad is presented Now Start!!")
     }*/
    /// Tells the delegate that the rewarded ad was dismissed.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed. ad finished or dispresent ")
        dismiss()
        
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func ad(_ ad: GADFullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded ad failed to present with error: \(error.localizedDescription).")
        dismiss()
    }
}

extension UIView{
    func anchor(
        
        top:NSLayoutYAxisAnchor? = nil,
        bottom:NSLayoutYAxisAnchor? = nil,
        left:NSLayoutXAxisAnchor? = nil,
        right:NSLayoutXAxisAnchor? = nil,
        centerY:NSLayoutYAxisAnchor? = nil,
        centerX:NSLayoutXAxisAnchor? = nil,
        width:CGFloat? = nil,
        height:CGFloat? = nil,
        topPadding: CGFloat = 0,
        bottomPadding: CGFloat = 0,
        leftPadding: CGFloat = 0,
        rightPadding: CGFloat = 0
    ){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top,constant: topPadding).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom,constant: -bottomPadding).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left,constant: leftPadding).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right,constant: -rightPadding).isActive = true
        }
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
