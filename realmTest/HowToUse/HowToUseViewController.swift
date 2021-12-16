//
//  HowToUseViewController.swift
//  PachinkoLog
//

import UIKit

class HowToUseViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var imageView7: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // スクリーンサイズの取得
        let screenW:CGFloat = view.frame.size.width
        let screenH:CGFloat = view.frame.size.height
        
        // 画像を読み込んで、準備しておいたimageSampleに設定
        imageView1.image = UIImage(named: "HowTo1")
        imageView2.image = UIImage(named: "HowTo2")
        imageView3.image = UIImage(named: "HowTo3")
        imageView4.image = UIImage(named: "HowTo4")
        imageView5.image = UIImage(named: "HowTo5")
        imageView6.image = UIImage(named: "HowTo6")
        imageView7.image = UIImage(named: "HowTo7")
        // 画像のフレームを設定
        imageView1.frame = CGRect(x:0, y:0, width:128, height:128)
        
        // 画像を中央に設定
        imageView1.center = CGPoint(x:screenW/2, y:screenH/2)
        
        // 設定した画像をスクリーンに表示する
        //self.view.addSubview(imageView1)
    }

    // UIImageViewを生成
    func createImageView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, image: String) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        let image = UIImage(named:  image)
        imageView.image = image
        return imageView
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
