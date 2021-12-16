//
//  AnalysisViewController.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/11/22.
//

import UIKit

class AnalysisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var categoryTable: UITableView!
    

    
    
    let dataCategoryArray = ["トータル", "ホール別", "機種別"]
    var categoryNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTable.dataSource = self
        categoryTable.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = dataCategoryArray[indexPath.row]
        return cell
    }
    
    // Cell が選択された場合
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "ToAnalysisDetaiView",sender: nil)
        }else{
            categoryNumber = indexPath.row
            performSegue(withIdentifier: "ToAnalysisCategory",sender: nil)
        }
    }
    
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "ToAnalysisDetaiView") {
            let subVC: AnalysisDetailViewController = (segue.destination as? AnalysisDetailViewController)!
            // SubViewController のselectedImgに選択された画像を設定する
            subVC.categoryNumber = self.categoryNumber
            subVC.categoryList = self.dataCategoryArray
        }else if segue.identifier == "ToAnalysisCategory"{
            let subVC: AnalysisCategoryViewController = (segue.destination as? AnalysisCategoryViewController)!
            subVC.categoryNumber = self.categoryNumber
        }
    }
}
