//
//  prevInput.swift
//  realmTest
//
//  Created by 東純己 on 2021/09/12.
//

import UIKit

class prevInput: UIViewController {
    
    public let MachineID = Int()
    @IBOutlet weak var testLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //testLabel.text! = "aaaaa"
        // Do any additional setup after loading the view.
        testLabel.text! = String(MachineID)
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
