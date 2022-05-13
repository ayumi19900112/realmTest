//
//  GoogleAdmobViewController.swift
//  PachinkoLog
//
//  Created by 東純己 on 2022/05/13.
//

import Foundation
import UIKit
import GoogleMobileAds

class GoogleAdmobViewController: UIViewController, GADBannerViewDelegate{
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        createBannerView()
    }
    
    //バナー広告
   private func createBannerView(){
       
       bannerView = GADBannerView(adSize: GADAdSizeBanner)
       bannerView.delegate = self
       bannerView.backgroundColor = .white

       if UserDefaults.standard.object(forKey: "buy") != nil{
           
           if UserDefaults.standard.object(forKey: "buy") as! Int == 1{
               bannerView.removeFromSuperview()
           }else {
               
               bannerView.adUnitID = bannerTestCode
               bannerView.rootViewController = self
               bannerView.load(GADRequest())
           }
       }else {
           bannerView.adUnitID = bannerTestCode
           bannerView.rootViewController = self
           bannerView.load(GADRequest())
       }
   }
   func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
       print("bannerViewDidReceiveAd")
       addBannerViewToView(bannerView)
       bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
          bannerView.alpha = 1
        })
   }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
        view.bringSubviewToFront(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: view.safeAreaLayoutGuide,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
}
