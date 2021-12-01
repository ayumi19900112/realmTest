//
//  AnalysisTotalViewController.swift
//  PachinkoLog
//
//  Created by 東純己 on 2021/12/01.
//

import UIKit
import RealmSwift

class AnalysisTotalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var totalTableView: UITableView!
    
    var idx = [Int]()
    var result: Results<ResultTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalTableView.delegate = self
        totalTableView.dataSource = self
        
        totalTableView.register (UINib(nibName: "AnalysisTotalCellTableViewCell", bundle: nil),forCellReuseIdentifier:"AnalysisTotalCell")
        
        idx = idx.sorted(by: >)
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idx.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = totalTableView.dequeueReusableCell(withIdentifier: "AnalysisTotalCell", for: indexPath) as! AnalysisTotalCellTableViewCell
        cell.setData(data: self.result[idx[indexPath.row]])
        return cell
    }
    

}
