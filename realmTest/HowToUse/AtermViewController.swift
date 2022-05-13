//
//  AtermViewController.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/11/07.
//

import UIKit

class AtermViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //プライバシーポリシー・お問い合わせ
    @IBAction func aterm(_ sender: Any) {
        let url = URL(string: "https://pachinkolog.com/contact/contact.php")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func howToButton(_ sender: Any) {
        let url = URL(string: "https://pachinkolog.com/howto/howToUse.php")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
